# encoding = UTF-8

module ContestIO
	def ReadStudentData( path )
		@StuData = Array.new
		File.open(path, :encoding => 'utf-8').each_line { |line|
			ac, nm, rt = line.split(' ') # account name rating
			@StuData << Student.new(ac, nm, rt)
		}
	end
	
	def ReadTeamData( path )
		@TeamData = Array.new; i = 0;
		File.open(path, :encoding => 'utf-8').each_line { |line|
			data = line.split(' ') # account name members
			ac = data[0]; nm = data[1];
			member = Array.new
			for i in 2...data.size
				@StuData.each { |x| (x.name == data[i]) && member << x }
			end
			team = Team.new(ac, nm, member)
			member.each { |s|
				@StuData.each { |x| (x.name == s) && x.add_observer(team) }
			}
			@TeamData << team
		}
		@TeamData.each { |x| x.get_rating; x.set_rating; }
	end
	
	def BuildAccountList()
		@AccountList = Array.new;
		(@ContestType == "SRM") && @StuData.each { |x| @AccountList << x }
		(@ContestType == "TRM") && @TeamData.each { |x| @AccountList << x }
	end
	
	def ReadContestResult( path )
		@Ranklist = Array.new; i = 0
		guest_no = 0
		File.open("guest_no.txt") { |f|
			guest_no = f.gets.to_i
		}
		puts("guest_no = #{guest_no}")
		File.open(path, :encoding => 'utf-8').each_line { |line|
			tmp = line.split(' ')
			rk = tmp[0] # rank
			ac = tmp[1] # account
			(@ContestType == "SRM") && base = Student.new
			(@ContestType == "TRM") && base = Team.new
			isGuest = 1
			@AccountList.each { |x| 
				if (ac == x.account) then
					base = x
					isGuest = 0
				end
			}
			if (isGuest == 1) then
				guest_no = guest_no + 1;
				name = "anonymous_No.#{guest_no}"
				rating = 1500
				base = Student.new(ac, name, rating)
				puts base.toString_s
				(@ContestType == "SRM") && @StuData << base
				(@ContestType == "TRM") && @TeamData << base
			end
			stu = Contestant.new(base, rk)
			@Ranklist << stu
		}
		File.open("guest_no.txt", "w+") { |f|
			f << guest_no
		}
	end

	def BuildContest()
		ReadStudentData("student.txt")
		ReadTeamData("team.txt")
		BuildAccountList()
		ReadContestResult("contest.txt")
		file = File.new("CurrentTeam.txt", "w+")
		@TeamData.each { |x| file.puts x.toString_l }
	end

	def WriteNewRating( stupath, teampath )
		if @ContestType == "SRM" then
			file = File.new(stupath, "w+")
			@StuData.each { |x|
				tmp = 0
				@Ranklist.each { |t|
					tmp = t._drating.to_i + t.base.rating.to_i if x.name == t.base.name
				}
				x.updateTo(tmp) unless tmp == 0
				x.miss if tmp == 0
				file.puts x.toString
			}
			file.close
			file = File.new(teampath, "w+")
			@TeamData.each { |x| 
				x._drating = 0
				x.teamMembers.each{ |t|
					@StuData.each { |s|
						x._drating += s.rating.to_i if s.name == t.name
					}
				}
				x.rebuild
				file.puts x.toStringShort
			}
			file.close
		elsif @ContestType == "TRM" then
			file = File.new(teampath, "w+")
			@TeamData.each { |x|
				tmp = 0
				@Ranklist.each { |t|
					tmp = t._drating.to_i + t.base.rating.to_i if x.name == t.base.name
				}
				x.updateTo(tmp) unless tmp == 0
				x.miss if tmp == 0
				file.puts x.toString
			}
			file.close
			file = File.new(stupath, "w+")
			@StuData.each { |x|
				@TeamData.each { |t|
					t.teamMembers.each { |s| x = s if x.name == s.name }
				}
				x.rebuild
				file.puts x.toString
			}
			file.close
		end
	end

	def WriteNewResult( path )
		file = File.new(path, "w+")
		@Ranklist.each { |data| data.modify; file.puts data.toString }
	end
	
	def Report()
		WriteNewRating("NewStudentData@#{Time.now.strftime("%F")}.txt", "NewTeamData@#{Time.now.strftime("%F")}.txt")
		WriteNewResult("Result@#{Time.now.strftime("%F")}.txt")
	end

end
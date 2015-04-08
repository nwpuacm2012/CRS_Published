# encoding = UTF-8

=begin
Rating算法：
针对两个参加比赛的人，互相比较，每次比较都更新一次_drating。

比较法则：
比较排名：高者胜，低者负；根据比较结果选取系数进行计算。

更新系数法则：
将本场的比赛系数按参赛人数分配给各个学生
计算方法如下：ef = $Kcef / sz

更新法则：
更新时，将两两同学互相比较，然后每次计算出的增量累加到_drating上即可
增量计算方法如下：
  A: dA = cef * (sA - eA) 
	B: dB = cef * (sB - eB)
最后直接累加即可。

读入数据格式：
学生目前信息 student.txt: account name rating
队伍目前信息 team.txt   : account name membernames
计算比赛信息 Contest.txt: rank account

输出数据格式：
赛前队伍积分 CurrentTeam       : name oldrating
赛后结果整理 Result.txt        : rank name oldrating newrating
赛后队伍积分 NewTeamData.txt   : name newrating
赛后个人积分 NewStudentData.txt: account name newrating
=end

class Student
	attr_accessor :account, :name, :rating
	
	def initialize( account = '', name = '', rating = 1500 )
		@account = account
		@name = name
		@rating = rating
		@isRobot = (account == "Robot") || (account == "ZZZ")
		@obvs = Array.new
	end
	
	def add_observer( obv ) # Add an obvserver
		@obvs << obv
	end
	
	def updateTo( frating ) # Update Rating to Final Rating
		@rating = frating.to_i
		(!@isRobot) && @obvs.each { |obv| obv.receiver(@rating) }
	end
	
	def receiver( drating ) # Wait update message
		@rating = @rating.to_i +  drating.to_i
	end
	
	def toString
		"#{@account}\t#{@name}\t#{@rating}"
	end
end

class Team
	attr_accessor :account, :name, :rating
	attr_accessor :teamMembers # type Student
	attr_accessor :_drating
	
	def initialize( account = "", name = "", members = [] )
		@account = account
		@name = name
		@obvs = Array.new(0, Student)
		@teamMembers = Array.new(0, Student)
		members.each { |x| @teamMembers << x }
		@teamCapacity = members.size
		# Set Team's Rating to Zero
		@rating = 0
		@_drating = 0
		@isRobot = (account == "Robot") || (account == "ZZZ")
		@teamMembers.each { |x| @obvs << x }
	end
	
	def set_observer # Add an obvserver
		@obvs = @teamMembers
	end
	
	def gets_rating # Get rating from members
		@_drating = 0 # add member's rating to _drating
		@teamMembers.each { |s| @_drating += s.rating.to_i }
	end
	
	def set_Rating # Set team's rating
		(@teamCapacity == 0) && @teamCapacity = 1
		@rating = @_drating / @teamCapacity.to_i
		@_drating = 0 
	end
	
	def updateTo( frating ) # Update Rating to Final Rating
		@_drating = frating.to_i - @rating.to_i
		@rating = frating.to_i;
		(!@isRobot) && @obvs.each { |obv| obv.receiver( @_drating) }
		@_drating = 0
	end
	
	def receiver( srating ) # Wait update message
		@_drating += srating.to_i
	end
	
	def toStringShort 
		"#{@name}\t#{@rating.to_i + @_drating.to_i}"
	end
	
	def toString
		res = "#{@account}\t#{@name}\t"
		@teamMembers.each { |s| res = res + "#{s.name}\t" }
		res = res + "#{@rating}"
	end
end

class Contestant
	attr_accessor :base, :rank
	attr_accessor :_drating, :_frating
	
	def initialize( base, rank ) 
		@base = base
		@rank = rank.to_i
		@_frating = 0
		@_drating = 0
	end
	
	def add_rating( d ) # Modifying the Delta of Rating
		@_drating += d
	end
	
	def modify # Update Rating After Contest
		@_frating = @base.rating.to_i + @_drating.to_i
		@_drating = 0
	end
	
	def toString
		return "#{@rank}\t#{@base.name}\t#{@base.rating.to_i}\t#{@_frating}"
	end
end

class Contest
	attr_accessor :Kcef, :ContestType
	
	def initialize( rate, type )
		@Kcef = rate.to_i     # Contest Coefficient
		@ContestType = type   # Default Contest Type
		@StuData  = Array.new # Students Data
		@TeamData = Array.new # Teams Data
		@Ranklist = Array.new # Contest Final Result
	end
	
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
				@StuData.each { |x| (x.name == data[i]) && member << x.clone }
			end
			team = Team.new(ac, nm, member)
			member.each { |s|
				@StuData.each { |x| (x.name == s) && x.add_observer(team) }
			}
			@TeamData << team
		}
		@TeamData.each { |x| x.gets_rating; x.set_Rating; }
	end
	
	def BuildAccountList()
		@AccountList = Array.new;
		(@ContestType == "SRM") && @StuData.each { |x| @AccountList << x.clone }
		(@ContestType == "TRM") && @TeamData.each { |x| @AccountList << x.clone }
	end
	
	def ReadContestResult( path )
		@Ranklist = Array.new; i = 0
		File.open(path, :encoding => 'utf-8').each_line { |line|
			tmp = line.split(' ')
			rk = tmp[0] # rank
			ac = tmp[1] # account
			(@ContestType == "SRM") && base = Student.new
			(@ContestType == "TRM") && base = Team.new
			@AccountList.each { |x| (ac == x.account) && base = x.clone }
			stu = Contestant.new(base, rk)
			@Ranklist << stu
		}
	end
	
	def BuildContest()
		ReadStudentData("student.txt")
		ReadTeamData("team.txt")
		BuildAccountList()
		ReadContestResult("contest.txt")
		file = File.new("CurrentTeam.txt", "w+")
		@TeamData.each { |x| file.puts x.toStringShort }
	end
	
	def calc_eA_eB(rA, rB)
		da = (rB - rA) / 400.0; db = -da
		ta = 10.0**da + 1.0; tb = 10.0**db + 1.0
		ea = 1.0 / ta; eb = 1.0 / tb;
		return [ea, eb]
	end

	def calc_sA_sB(a, b)
		if a < b then
			[1.0, 0.0] 
		elsif a == b then
			[0.5, 0.5] 
		else
			[0.0, 1.0]
		end
	end

	def competition(a, b, sz) # 修改两人的增量
		eA, eB = calc_eA_eB(a.base.rating.to_f, b.base.rating.to_f)
		sA, sB = calc_sA_sB(a.rank.to_i, b.rank.to_i)
		cef = @Kcef / sz.to_f
		dA = (sA - eA) * cef
		dB = (sB - eB) * cef
		a.add_rating(dA)
		b.add_rating(dB)
	end
	
	def Run()
		# 逐一比较
		sz = @Ranklist.size
		@Ranklist.each { |i|
			@Ranklist.each { |j|
				competition(i, j, sz.to_i) unless i == j
			}
		}
	end
	
	def WriteNewRating( stupath, teampath )
		if @ContestType == "SRM" then
			file = File.new(stupath, "w+")
			@StuData.each { |x|
				tmp = 0
				@Ranklist.each { |t|
					tmp = t._drating.to_i + t.base.rating.to_i if x.name == t.base.name
				}
				minus = @Kcef.to_i / 3
				tmp = x.rating.to_i - minus.to_i if tmp == 0 
				x.updateTo(tmp)
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
				x.set_Rating
				file.puts x.toStringShort
			}
		elsif @ContestType == "TRM" then
			file = File.new(teampath, "w+")
			@TeamData.each { |x|
				tmp = 0
				@Ranklist.each { |t|
					tmp = t._drating.to_i + t.base.rating.to_i if x.name == t.base.name
				}
				minus = @Kcef.to_i / 5 * 2
				tmp = x.rating.to_i - minus.to_i if tmp == 0 
				x.updateTo(tmp)
				file.puts x.toStringShort
			}
			file.close
			file = File.new(stupath, "w+")
			@StuData.each { |x|
				@TeamData.each { |t|
					t.teamMembers.each { |s| x = s.clone if x.name == s.name }
				}
				file.puts x.toString
			}
		end
	end

	def WriteNewResult( path )
		file = File.new(path, "w+")
		@Ranklist.each { |data| data.modify; file.puts data.toString }
	end
	
	def Report()
		WriteNewRating("NewStudentData.txt", "NewTeamData.txt")
		WriteNewResult("Result.txt")
	end
	
	def Setup()
		BuildContest()
		Run()
		Report()
	end
end

Test = Contest.new(100, "SRM")
Test.Setup()
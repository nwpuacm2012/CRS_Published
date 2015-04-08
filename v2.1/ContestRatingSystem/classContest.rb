# encoding = UTF-8

class Contest
	attr_accessor :Kcef, :ContestType
	
	def initialize( rate, type )
		@Kcef = rate.to_i     # Contest Coefficient
		@ContestType = type   # Default Contest Type
		@StuData  = Array.new # Students Data
		@TeamData = Array.new # Teams Data
		@Ranklist = Array.new # Contest Final Result
	end
	
	include ContestCore
	include ContestIO
	
	def Setup()
		BuildContest()
		Run()
		Report()
	end
end
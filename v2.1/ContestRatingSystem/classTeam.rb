# encoding = UTF-8

class Team
	include ContestantBase
	attr_accessor :teamMembers # type Student

	def initialize( account = '', name = '', members = [] )
		@account, @name  = account, name
		@isRobot = (account == "Robot") || (account == "ZZZ")
		@obvs = Array.new(0, Student) # Obvserver Set
		@teamMembers = Array.new(0, Student)
		members.each { |x| @teamMembers << x }
		@teamCapacity = @teamMembers.size
		# set team's rating to zero
		@rating = 0 # team's rating
		@_drating = 0 # temporary rating before update
		@obvs = @teamMembers # set obvservers
		get_rating
		set_rating
	end

	def get_rating # get rating from members
		@_drating = 0 # add member's rating to _drating
		@teamMembers.each { |s| @_drating += s.rating.to_i }
	end

	def set_rating # set team's rating
		(@teamCapacity == 0) && @teamCapacity = 1
		@rating = @_drating / @teamCapacity.to_i
		@oldrating, @_drating = @rating, 0
	end

	def rebuild
		@oldrating = @rating
		@rating = @_drating / @teamCapacity.to_i
		@newrating, @_drating = @rating, 0
	end
	
	def toString_l
		res = "#{@account}\t#{@name}\t"
		@teamMembers.each { |s| res << "#{s.name}\t" }
		res << "#{@oldrating}\t#{newrating}"
	end

end
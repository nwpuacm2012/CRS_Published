# encoding = UTF-8

class Student
	include ContestantBase

	def initialize( account = '', name = '', rating = 1500 )
		@account, @name, @rating  = account, name, rating
		@isRobot = (account == "Robot") || (account == "ZZZ")
		@obvs = Array.new # Obvserver set
		@_drating = 0 # temporary rating before update
	end
	
	def add_observer( obv ) # add an obvserver
		@obvs << obv
	end

	def rebuild
		@oldrating = @rating.to_i
		@newrating = @rating.to_i + @_drating.to_i
		@rating, @_drating = @newrating, 0
	end
end
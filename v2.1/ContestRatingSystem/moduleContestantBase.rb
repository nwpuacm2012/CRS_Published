# encoding = UTF-8

module ContestantBase
	attr_accessor :account, :name, :rating
	attr_accessor :oldrating, :newrating
	attr_accessor :_drating
	attr_reader :isRobot

	def toString
		"#{@account}\t#{@name}\t#{@oldrating}\t#{newrating}"
	end

	def toString_s
		"#{@account}\t#{name}\t#{@rating}"
	end

	def updateTo( frating ) # update rating to final rating
		@oldrating = @rating.to_i
		@newrating = frating.to_i
		@rating = @newrating.to_i
		tmp = @newrating - @oldrating
		(!@isRobot) && @obvs.each { |obv| obv.receiver(tmp) }
		@_drating = 0
	end

	def receiver( drating ) # receive update message
		@_drating += drating.to_i
	end

	def miss
		@oldrating = @rating
		@newrating = @rating
	end
end
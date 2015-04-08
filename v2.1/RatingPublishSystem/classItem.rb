# encoding = UTF-8
class Item
    attr_reader :rank, :name, :oldrating, :newrating
	attr_reader :change
	def initialize( str )
		@rank, @name, @oldrating, @newrating = str.split(" ")
		@rank = @rank.to_i
		@oldrating = @oldrating.to_i
		@newrating = @newrating.to_i
		@change = @newrating - @oldrating
	end
end
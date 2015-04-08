# encoding = UTF-8

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
		"#{@rank}\t#{@base.name}\t#{@base.oldrating.to_i}\t#{@base.newrating.to_i}"
	end
end 
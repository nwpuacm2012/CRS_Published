# encoding = UTF-8

class Contestant
	attr_accessor :name
	attr_accessor :rating
	attr_accessor :rank
	attr_accessor :_drating
  
	def initialize(name, rak, rtg)
		@rank = rak.to_i
		@name = name
		@rating = rtg.to_i
		@_drating = 0
	end
  
	def update(d) # 累加 rating 改变量
		@_drating += d
	end
	
	def modify # 更新rating
		@rating += @_drating
		@_drating = 0
		@rating = @rating.to_i
	end
  
	def toString
		return "#{@rank}\t#{@name}\t#{@rating}"
	end
end

class Student
	attr_accessor :name
	attr_accessor :rating
	
	def initialize(name, rating)
		@name = name
		@rating = rating.to_i
	end
	
	def toStringLine
		return "#{@name}\t#{@rating}\n"
	end
end

=begin
Rating算法：
针对两个参加比赛的人，互相比较，每次比较都更新一次_drating。

比较法则：
比较排名：高者胜，低者负；
根据比较结果选取系数进行计算。

更新系数法则：
将本场的比赛系数按参赛人数分配给各个学生
计算方法如下：
  cef = $Kcef / sz

更新法则：
更新时，将两两同学互相比较，然后每次计算出的增量累加到_drating上即可
增量计算方法如下：
  A: dA = cef * (sA - eA)
  B: dB = cef * (sB - eB)
最后直接累加即可。
=end

$Kcef = 100       # 比赛的系数
$Data = Array.new # 姓名分数匹配表
$List = Array.new # 按照Rank排序的初始Rating表
$Rank = Array.new # 最终的Ranklist数据表

def calc_eA_eB(rA, rB)
	da = (rB - rA) / 400.0; db = -da
	ta = 10.0**da + 1.0; tb = 10.0**db + 1.0
	ea = 1.0 / ta; eb = 1.0 / tb;
	return [ea, eb]
end

def calc_sA_sB(a, b)
	if a < b then
		[1.0, 0.0] 
	else
		[0.0, 1.0]
	end
end

def competition(a, b, sz) # 修改两人的增量
	eA, eB = calc_eA_eB(a.rating.to_f, b.rating.to_f)
	sA, sB = calc_sA_sB(a.rank.to_i, b.rank.to_i)
	cef = $Kcef / sz.to_f
	dA = (sA - eA) * cef
	dB = (sB - eB) * cef
	a.update(dA)
	b.update(dB)
end

def ReadCurrentRating( path )
	$Data = Array.new; i = 0
	File.open(path, :encoding => 'utf-8').each_line { |line|
		i = i + 1
		unless i == 1 then
			nm, rt = line.split(' ') # name rating
			$Data << Student.new(nm, rt)
		end
	}
end

def ReadContestResult( path )
	$Rank = Array.new; i = 0
	File.open(path, :encoding => 'utf-8').each_line { |line|
		i = i + 1
		unless i == 1 then
			tmp = line.split(' ')
			rk = tmp[0] # rank
			nm = tmp[1] # name
			rt = 0      # rating
			$Data.each { |x| if x.name == nm then rt = x.rating end }
			stu = Contestant.new(nm, rk, rt)
			$Rank << stu
		end
	}
end

def WriteNewRating( path )
	file = File.new(path, "w+")
	$Data.each { |x|
		tmp = 0
		$Rank.each { |t| if x.name == t.name then tmp = t.rating end }
		if tmp == 0 then tmp = x.rating - 40 end
		x.rating = tmp
		file.print x.toStringLine
	}
end

def WriteNewResult( path )
	file = File.new("result.txt", "w+")
	i = 0
	$Rank.each { |data|
		data.modify
		file.print data.toString
		file.print "\t"
		file.print $List[i].to_s
		file.print "\n"
		i = i + 1
	}
end


def RunMain()
	sz = $Rank.size
	# 逐一比较
	for i in 0...sz
		for j in 0...sz
			if i == j then
			  next
			else 
			  competition($Rank[i], $Rank[j], sz.to_i);
			end 
		end
	end
	
	$List = Array.new
	$Rank.each { |data| $List << data.rating }
	
	# 自身比较
	$Rank.each { |data|
		temp = data
		temp.modify # 更新这场的rating
		competition(temp, data, sz)
		temp.modify # 自我比较后的rating
		data.modify # 对 rating 取平均值
		data.rating = ((temp.rating.to_i + data.rating.to_i ) / 2).to_i
	}
end

ReadCurrentRating("current.txt")
ReadContestResult("contest.txt")
RunMain()
WriteNewRating("rating.txt")
WriteNewResult("result.txt")

=begin
读入数据格式
current.txt: name rating
contedt.txt: rank name

输出数据格式
rating.txt: name newrating
result.txt: rank name newrating oldrating
=end
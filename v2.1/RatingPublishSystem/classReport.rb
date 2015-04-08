# encoding = UTF-8

class Report
	include ReportHTML
	attr_accessor :filename # HTML Document Name

	def initialize( dst, flag_1, flag_2, flag_3 )
		@filename = dst;
		@rkf_1, @rkf_2, @rkf_3 = flag_1, flag_2, flag_3

@strHtmlHead = <<htmlhead
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html" charset = "utf-8">
	<title>Board|Contest Rating System</title>
	<link rel="stylesheet" href="board.css" type="text/css" />
</head>
<body><div class="container">
htmlhead

@strHtmlEnd = <<htmlend
</body>
</html>
htmlend

@strHtmlTableHead = <<htmltablehead
	<table id="crsboard">
		<thead>
			<th> Rank </th>
			<th> Name </th>
			<th> Old Rating </th>
			<th> New Rating </th>
			<th> Change </th>
		</thead>
htmltablehead

@strHtmlTableEnd = "\t</table>\n"
	end

	def selectRankBgColor( rank )
		flag = ""
		if rank <= @rkf_1 then flag = "fst"
		elsif rank <= @rkf_2 then flag = "sec"
		elsif rank <= @rkf_3 then flag = "trd"
		else flag = "otr"
		end
		%Q{\t\t\t<th class="#{flag}"> #{rank} </th>}
	end

	def selectRatingColor( rating )
		flag = ""
		if rating >= 2600 then flag = "r26p"
		elsif rating >= 2200 then flag = "r22p"
		elsif rating >= 2050 then flag = "r20p"
		elsif rating >= 1900 then flag = "r19p"
		elsif rating >= 1700 then flag = "r17p"
		elsif rating >= 1500 then flag = "r15p"
		elsif rating >= 1350 then flag = "r13p"
		elsif rating >= 1200 then flag = "r12p"
		else flag = "r12d"
		end
		%Q{\t\t\t<th class="#{flag}"> #{rating} </th>}
	end

	def selectChangeColor( change )
		flag = ""
		if change >= 0 then flag = "cp"
		else flag = "cd"
		end
		%Q{\t\t\t<th class="#{flag}"> #{change} </th>}
	end

	def printMsg( filename, msg )
		return if ((msg.name == "Robot") || ((msg.name == "DDD")))
		file = File.open(filename, "a+")
		# print row option
		file.puts %Q{\t\t<tr class="row#{2 - msg.rank % 2}">}
		# print rank option
		file.puts selectRankBgColor(msg.rank)
		# print name
		file.puts %Q{\t\t\t<th> #{msg.name} </th>}
		# print old rating
		file.puts selectRatingColor(msg.oldrating)
		# print new rating
		file.puts selectRatingColor(msg.newrating)
		# print change
		file.puts selectChangeColor(msg.change)
		# print end of this row
		file.puts %Q{\t\t</tr>}
		file.close
	end

end
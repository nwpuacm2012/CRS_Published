# encoding = UTF-8

module ReportHTML

	def printHtmlHead( filename )
		file = File.new(filename, "w+")
		file.print @strHtmlHead
		file.close
	end

	def printHtmlEnd( filename )
		file = File.open(filename, "a+")
		file.print @strHtmlEnd
		file.close
	end

	def printHtmlTableHead( filename )
		file = File.open(filename, "a+")
		file.print @strHtmlTableHead
		file.close
	end

	def printHtmlTableEnd( filename )
		file = File.open(filename, "a+")
		file.print @strHtmlTableEnd
		file.close
	end

	def printHtmlTitle( filename, type, div )
		file = File.new(filename, "a+")
		date = "#{Time.now.strftime("%F")}"
		name = "#{type}(#{div})"
		file.print %Q{\t<h1>#{$title} #{name} @ #{date}</h1>\n}
		file.print %Q{\t<div class="footer">\n}
		file.print %Q{\t\t<p>origin: #{$title} #{name}</p>\n}
		file.print %Q{\t</div>\n}
		file.close
	end

	def printHtmlTitleLast( filename, type, div )
		file = File.new(filename, "a+")
		date = "#{Time.now.strftime("%F")}"
		name = "#{type}(#{div})"
		file.print %Q{\t<h1>Last Board @ #{date}</h1>\n}
		file.print %Q{\t<div class="footer">\n}
		file.print %Q{\t\t<p>origin: #{$title} #{name}</p>\n}
		file.print %Q{\t</div>\n}
		file.close
	end

	def printHtmlFooter( filename )
		file = File.open(filename, "a+")
		file.print %Q{\t<div class="footer">\n}
		date = "#{Time.now.strftime("%F %T")}"
		file.print %Q{\t\t<p>Generated @ #{date}</p>\n}
		file.print %Q{\t</div>\n}
		file.close
	end

end
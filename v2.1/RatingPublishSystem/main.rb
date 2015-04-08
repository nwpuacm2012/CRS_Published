# encoding = UTF-8
require_relative "moduleHTML"
require_relative "classReport"
require_relative "classItem"
$title = "NWPU2015"
type = ARGV[0].to_s + " - " + format("%02d", ARGV[1].to_i)
div = "div.#{ARGV[2].to_i}"
srcfile = "Result@#{Time.now.strftime("%F")}.txt"
dstfile = "Summary@#{Time.now.strftime("%F")}.html"
cnt, items = 0, Array.new
File.open(srcfile, :encoding => 'utf-8').each_line { |line|
	tmp = Item.new(line.chomp)
	cnt = cnt + 1
	items << tmp
}

_1st_flag = (cnt * 0.10).floor
_2nd_flag = (cnt * 0.25).floor
_3rd_flag = (cnt * 0.60).floor

out = Report.new(dstfile, _1st_flag, _2nd_flag, _3rd_flag)
out.printHtmlHead(dstfile)
out.printHtmlTitle(dstfile, type, div)
out.printHtmlTableHead(dstfile)
items.each{ |i|
	out.printMsg(dstfile, i)
}
out.printHtmlTableEnd(dstfile)
out.printHtmlFooter(dstfile)
out.printHtmlEnd(dstfile)

resfile = "Summary.html"
out = Report.new(resfile, _1st_flag, _2nd_flag, _3rd_flag)
out.printHtmlHead(resfile)
out.printHtmlTitleLast(resfile, type, div)
out.printHtmlTableHead(resfile)
items.each{ |i|
	out.printMsg(resfile, i)
}
out.printHtmlTableEnd(resfile)
out.printHtmlFooter(resfile)
out.printHtmlEnd(resfile)

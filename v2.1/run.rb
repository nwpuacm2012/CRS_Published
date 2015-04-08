# encoding = UTF-8
require 'fileutils'

coef = ARGV[0].to_i
type = ARGV[1].to_s
no   = ARGV[2].to_i
div  = ARGV[3].to_i
# in Ubuntu
# home = "/home/acm/crs"
# in Windows
home = "____"
crs = "ContestRatingSystem"
rps = "RatingPublishSystem"
date = Time.now.strftime("%F")

# Calculate this contest rating
FileUtils.cd("#{crs}")
system("ruby main.rb #{coef} #{type}")
FileUtils.cd("..")

# Copy file for further usage
rfn = "Result@#{date}.txt" # Result File Name
FileUtils.cp("#{home}/#{crs}/#{rfn}", "#{home}/#{rps}/")
FileUtils.cd("#{rps}")
system("ruby main.rb #{type} #{no} #{div}")
FileUtils.cd("..")

# Copy Summary Html Document for further usage
sfn = "Summary@#{date}.html" # Summary File Name
lfn = "Summary.html" # Last Summary File Name
FileUtils.cp("#{home}/#{rps}/#{sfn}", home)
FileUtils.cp("#{home}/#{rps}/#{lfn}", home)

puts "Finish"

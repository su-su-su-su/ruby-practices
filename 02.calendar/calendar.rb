#!/usr/bin/env ruby
require "date"
require 'optparse'

  def firstweek(day_first, day_end)
    day_first.upto(day_end) {|d|
      if d.mday == 1 && d.saturday?
        puts "#{' '.rjust(3) * d.wday}#{d.day.to_s.rjust(3)}"
      elsif d.mday == 1
        print "#{' '.rjust(3) * d.wday}#{d.day.to_s.rjust(3)}"
      end
    }
  end
  def second_week_onwards(day_first, day_end)
    day_first.upto(day_end) {|d|
      if d.day == 1
        next
      end
      print  d.day.to_s.rjust(3)
      if  d.saturday? 
        puts 
      end
    }
  end

now = Date.today
options = ARGV.getopts("y:", "m:")
yaer = options["y"] ? options["y"].to_i : now.year
month = options["m"] ? options["m"].to_i : now.month
day_first = Date.new( yaer, month,  1)
day_end = Date.new( yaer, month,  -1)
print "  " * 3 + day_first.month.to_s + "月 "
puts day_first.year
puts " 日 月 火 水 木 金 土 "
firstweek(day_first, day_end)
second_week_onwards(day_first, day_end)

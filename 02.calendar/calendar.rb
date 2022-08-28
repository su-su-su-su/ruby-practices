#!/usr/bin/env ruby
require "date"
require 'optparse'
class Calendar

  def firstweek(day_first, day_end)
    day_first.upto(day_end) {|d|
      if d.mday == 1 && d.sunday?
        return print "  " + d.day.to_s + " "
      elsif print "  " + " "
      elsif d.mday == 1 && d.monday? 
        return  print "  " + d.day.to_s + " "
      elsif print "  " + " "
      elsif d.mday == 1 && d.tuesday?
        return  print "  " + d.day.to_s + " "
      elsif print "  " + " "
      elsif d.mday == 1 && d.wednesday? 
        return print "  " + d.day.to_s + " "
      elsif print "  " + " "
      elsif d.mday == 1 && d.thursday? 
        return  print "  " + d.day.to_s + " "
      elsif print "  " + " "
      elsif d.mday == 1 && d.friday? 
        return  print "  " + d.day.to_s + " "
      elsif print "  " + " "
      elsif d.mday == 1 && d.saturday? 
        return  print "  " + d.day.to_s + " "
      elsif print "  " + " "
      end
    }
  end
  def second_week_onwards(day_first, day_end)
    day_first.upto(day_end) {|d|
      if d.day == 1
        next
      elsif  d.day == 2 && d.sunday?
        puts
        print " " + " " + d.day.to_s + " "
      elsif  d.day <= 9 && d.saturday?
        puts " " + d.day.to_s + " "
      elsif d.mday <= 9 && d.sunday?
        print " " + " " + d.day.to_s + " "
      elsif d.sunday?
        print " " + d.day.to_s + " "
      elsif  d.mday <= 9 && d.saturday?
        puts " " + d.day.to_s + " "
      elsif d.saturday?
          puts d.day.to_s + " "
      elsif d.mday <= 9
         print " " + d.day.to_s + " "
       else
          print d.day.to_s + " "
      end
    }
  end
end

calendar = Calendar.new
now = Date.today
options = ARGV.getopts("y:", "m:")
yaer = options["y"] ? options["y"].to_i : now.year
month = options["m"] ? options["m"].to_i : now.month
day_first = Date.new( yaer, month,  1)
day_end = Date.new( yaer, month,  -1)
print "  " + "  " + "  " + day_first.month.to_s + "月 "
puts day_first.year
calendar.firstweek(day_first, day_end)
calendar.second_week_onwards(day_first, day_end)

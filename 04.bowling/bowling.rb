#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
frames = []
scores.each do |s|
  shots << if s == 'X' # strike
             10
           else
             s.to_i
           end
  if shots[0] == 10
  elsif shots.size == 1
    next
  end
  frames << shots
  shots = []
end
point = 0
frames.each_with_index do |frame, i|
  point += if i == 9 && frame[0] == 10 # 10フレーム目に1回ストライク取った場合
             10
           elsif i == 10 && frame[0] == 10 # 10フレーム目に2回ストライク取った場合
             10
           elsif i == 11 && frame[0] == 10 # 10フレーム目に3回ストライク取った場合
             10
           elsif frame[0] == 10 && frames[i + 1][0] == 10 # 2回連続でストライクを取った場合
             (frames[i + 1].sum + frames[i + 2][0] + frame.sum)
           elsif frame[0] == 10 # ストライクを取った場合
             (frames[i + 1].sum + frame.sum)
           elsif i == 9 && frame.sum == 10 # 10フレーム目にスペアを取った場合
             (frames[9].sum + shots.last(1).sum)
           elsif frame.sum == 10 # スペアを取った場合
             frames[i + 1][0] + frame.sum
           else
             frame.sum
           end
end
p point

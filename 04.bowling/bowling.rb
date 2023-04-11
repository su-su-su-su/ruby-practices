#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
shots = []
frames = []
scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)
  next if shots.size == 1 && shots[0] <= 9

  frames << shots
  shots = []
end
point = 0
DEFEATED_ALL = 10
frames.each_with_index do |frame, i|
  point += if i >= 9 && frame[0] == DEFEATED_ALL # 10フレーム目にストライク取った場合
             10
           elsif frame[0] == DEFEATED_ALL && frames[i + 1][0] == DEFEATED_ALL # 2回連続でストライクを取った場合
             (frames[i + 1].sum + frames[i + 2][0] + frame.sum)
           elsif frame[0] == DEFEATED_ALL # ストライクを取った場合
             (frames[i + 1].sum + frame.sum)
           elsif i == 9 && frame.sum == DEFEATED_ALL # 10フレーム目にスペアを取った場合
             (frames[9].sum + shots.last(1).sum)
           elsif frame.sum == DEFEATED_ALL # スペアを取った場合
             frames[i + 1][0] + frame.sum
           else
             frame.sum
           end
end
p point

# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @shots = shots
  end

  def group_frames
    shots = []
    frame = []
    @shots.each do |s|
      s = s.to_i unless s == 'X'
      if s == 'X'
        frame << Frame.new([s])
      else
        shots << s
        next if shots.size == 1 && shots[0] <= 9

        frame << Frame.new(shots)
        shots = []
      end
    end
    frame
  end

  def print_scores
    point = 0
    group_frames.each_with_index do |frame, i|
      point += if i >= 9 && frame.strike?
                 10
               elsif frame.strike?
                 calculate_strike_score(frame, i)
               elsif frame.spear?
                 calculate_spare_score(frame, i)
               else
                 frame.score
               end
    end
    p point
  end

  def calculate_strike_score(frame, index)
    if frame.strike? && group_frames[index + 1].first_shot.point == 10 # 2回連続でストライクを取った場合
      (group_frames[index + 1].score + group_frames[index + 2].first_shot.point + frame.score)
    elsif frame.strike?
      (group_frames[index + 1].score + frame.score)
    end
  end

  def calculate_spare_score(frame, index)
    if index >= 9 && frame.spear?
      (group_frames[9].score + @shots.last.to_i) # 10フレーム目にスペアを取った場合
    else
      (group_frames[index + 1].first_shot.point + frame.score)
    end
  end
end

shots = ARGV[0].split(',')
game = Game.new(shots)
game.print_scores

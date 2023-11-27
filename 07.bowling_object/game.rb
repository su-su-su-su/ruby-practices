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
      next_frame = group_frames[i + 1]
      next_next_frame = group_frames[i + 2]

      point += if i >= 9 && frame.strike?
                 10
               elsif frame.strike?
                 frame.calculate_strike_score(next_frame, next_next_frame)
               elsif frame.spear?
                 frame.calculate_spare_score(next_frame)
               else
                 frame.score
               end
    end
    p point
  end
end

shots = ARGV[0].split(',')
game = Game.new(shots)
game.print_scores

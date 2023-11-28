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
      if s != 'X'
        s = s.to_i
        shots << s
        next if shots.size == 1 && shots[0] <= 9

        frame << Frame.new(shots)
        shots = []
      else
        frame << Frame.new([s])
      end
    end
    frame
  end

  def print_scores
    point = 0
    group_frames.each_with_index do |frame, index|
      last_shot = @shots.last.to_i
      next_frame = group_frames[index + 1]
      next_next_frame = group_frames[index + 2]

      point += if frame.strike?
                 frame.calculate_strike_score(last_shot, index, next_frame, next_next_frame)
               elsif frame.spare?
                 frame.calculate_spare_score(last_shot, index, next_frame)
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

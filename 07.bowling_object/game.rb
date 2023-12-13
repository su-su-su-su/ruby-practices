# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @frames = group_frames(shots)
  end

  def group_frames(shots)
    frame_shots = []
    frames = []
    shots.each do |s|
      if s != 'X'
        s = s.to_i
        frame_shots << s
        handle_shot(frame_shots, frames)

      elsif frames.size == 9 && frame_shots.size <= 2
        frame_shots << s
        if frame_shots.size == 3
          frame_shots << s
          frames << Frame.new(frame_shots)
        end
      else
        frames << Frame.new([s])
      end
    end
    frames
  end

  def handle_shot(shots, frames)
    if frames.size == 9 && shots.size == 2
      handle_final_frame(shots, frames)
    elsif shots.size == 1 && shots[0] <= 9
      nil
    else
      frames << Frame.new(shots)
      shots.clear
    end
  end

  def handle_final_frame(shots, frames)
    if shots[0].to_i + shots[1].to_i == 10 || shots[0] == 'X'
      nil
    else
      frames << Frame.new(shots)
      shots.clear
    end
  end

  def print_scores
    point = 0
    @frames.each_with_index do |frame, index|
      next_frame = @frames[index + 1]
      next_next_frame = @frames[index + 2]

      point += if frame.strike?
                 frame.calculate_strike_score(index, next_frame, next_next_frame)
               elsif frame.spare?
                 frame.calculate_spare_score(index, next_frame)
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

# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @frames = group_frames(shots)
  end

  def print_scores
    point = 0
    @frames.each_with_index do |frame, index|
      next_frame = @frames[index + 1]
      next_next_frame = @frames[index + 2]
      point += if frame.strike? && index <= 8
                 frame.calculate_strike_score(index, next_frame, next_next_frame)
               elsif frame.spare? && index <= 8
                 frame.calculate_spare_score(index, next_frame)
               else
                 frame.score
               end
    end
    p point
  end

  private

  def group_frames(shots)
    frame_shots = []
    frames = []
    shots.each_with_index do |shot, index|
      frame_shots << shot
      if frames.size == 9
        handle_final_frame(frame_shots, frames, index, shots)
        next
      end
      if shot == 'X' || frame_shots.size == 2
        frames << Frame.new(frame_shots)
        frame_shots = []
      end
    end
    frames
  end

  def handle_final_frame(frame_shots, frames, index, shots)
    frames << Frame.new(frame_shots) if index == shots.size - 1
  end
end

shots = ARGV[0].split(',')

game = Game.new(shots)

game.print_scores

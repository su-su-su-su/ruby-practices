# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
    @third_shot = Shot.new(frame[2])
  end

  def strike?
    @first_shot.point == 10
  end

  def spare?
    !strike? && score == 10
  end

  def score
    [first_shot.point, second_shot.point, third_shot.point].sum
  end

  def calculate_strike_score(index, next_frame = nil, next_next_frame = nil)
    if index == 8
      (next_frame.first_shot.point + next_frame.second_shot.point + score)
    elsif index == 9
      score
    elsif  next_frame.first_shot.point == 10
      (next_frame.score + next_next_frame.first_shot.point + score)
    else
      (next_frame.score + score)
    end
  end

  def calculate_spare_score(index, next_frame = nil)
    if index == 9
      score
    else
      (next_frame.first_shot.point + score)
    end
  end
end

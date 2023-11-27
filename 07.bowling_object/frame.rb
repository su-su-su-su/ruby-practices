# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
  end

  def strike?
    @first_shot.point == 10
  end

  def spare?
    !strike? && score == 10
  end

  def score
    [first_shot.point, second_shot.point].sum
  end

  def calculate_strike_score(next_frame, next_next_frame)
    if strike? && next_frame.first_shot.point == 10
      (next_frame.score + next_next_frame.first_shot.point + score)
    elsif strike?
      (next_frame.score + score)
    end
  end

  def calculate_spare_score(next_frame)
    return unless spare?

    (next_frame.first_shot.point + score)
  end
end

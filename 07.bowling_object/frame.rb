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

  def spear?
    !strike? && score == 10
  end

  def score
    [first_shot.point, second_shot.point].sum
  end
end

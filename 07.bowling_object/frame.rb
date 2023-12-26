# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
    @third_shot = Shot.new(frame[2])
  end

  DEFEATED_ALL = 10

  def strike?
    @first_shot.point == DEFEATED_ALL
  end

  def spare?
    !strike? && score == DEFEATED_ALL
  end

  def score
    [first_shot.point, second_shot.point, third_shot.point].sum
  end

  def all_shots
    [first_shot, second_shot, third_shot]
  end

  def calculate_strike_score(_index, next_frame = nil, next_next_frame = nil)
    all_shots_of_next_two_frames = (next_frame&.all_shots || []) + (next_next_frame&.all_shots || [])
    all_positive_shots = all_shots_of_next_two_frames.select { _1.point.positive? }
    additional_score = all_positive_shots.slice(0, 2).sum(&:point)
    DEFEATED_ALL + additional_score
  end

  def calculate_spare_score(_index, next_frame = nil)
    all_shots_of_next_two_frames = (next_frame&.all_shots || []) + (next_next_frame&.all_shots || [])
    all_positive_shots = all_shots_of_next_two_frames.select { _1.point.positive? }
    additional_score = all_positive_shots.slice(0, 1).sum(&:point)
    DEFEATED_ALL + additional_score
  end
end

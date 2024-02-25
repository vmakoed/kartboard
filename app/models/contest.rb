class Contest < ApplicationRecord
  has_many :contestants, dependent: :destroy
  has_many :users, through: :contestants

  accepts_nested_attributes_for :contestants,
    reject_if: proc { |attributes| attributes['user_id'].blank? }

  validate :places_within_sequence
  validate :contestants_size_within_range

  private

  def places_within_sequence
    places = contestants.map(&:place).compact.sort
    return if places.empty?

    place_counts = places.each_with_object(Hash.new(0)) { |place, counts| counts[place] += 1 }

    expected_next_place = 1
    place_counts.each do |place, count|
      if place != expected_next_place
        errors.add(:contestants, "invalid progression of places, expected #{expected_next_place} got #{place}")
        return
      end

      expected_next_place += count
    end
  end

  def contestants_size_within_range
    return if contestants.size.in?(
      (Contestant::PLACES.min + 1)..Contestant::PLACES.max
    )

    errors.add(:contestants, "must be at least 2 and at most 4 in size")
  end
end

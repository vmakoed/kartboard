class Contest < ApplicationRecord
  belongs_to :created_by, class_name: 'User'

  has_many :contestants, dependent: :destroy
  has_many :users, through: :contestants

  accepts_nested_attributes_for :contestants,
    reject_if: proc { |attributes| attributes['user_id'].blank? }

  validate :places_within_sequence
  validate :contestants_size_within_range
  validate :unique_contestants_by_user

  private

  def places_within_sequence
    places = contestants.map(&:place).compact.sort
    return if places.empty?

    place_counts = places.each_with_object(Hash.new(0)) { |place, counts| counts[place] += 1 }

    expected_next_place = 1
    place_counts.each do |place, count|
      if place != expected_next_place
        errors.add(
          :contestants,
          "have invalid placement, expected #{expected_next_place.ordinalize}" +
            " place instead of #{place.ordinalize} place"
        )
        return
      end

      expected_next_place += count
    end
  end

  def contestants_size_within_range
    return if contestants.size.in?(
      (Contestant::PLACES.min + 1)..Contestant::PLACES.max
    )

    errors.add(:base, "The number of participants must be between 2 and 4")
  end

  def unique_contestants_by_user
    return if contestants.map(&:user_id).uniq.size == contestants.size

    errors.add(:base, "A single user cannot participate more than once")
  end
end

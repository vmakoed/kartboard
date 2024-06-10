class Player < ApplicationRecord
  DEFAULT_SCORE = 1000

  belongs_to :user
  belongs_to :game
  has_many :contestants

  validates :score, numericality: { greater_than_or_equal_to: 0 }
  validates :game, uniqueness: { scope: :user }

  scope :with_contestants, -> { joins(:contestants).distinct }

  def user_name
    user.name
  end
end

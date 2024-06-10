class Game < ApplicationRecord
  has_many :contests, dependent: :destroy
  has_many :contestants, through: :contests
  has_many :players, dependent: :destroy

  validates :title, presence: true
end

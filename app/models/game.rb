class Game < ApplicationRecord
  has_many :contests

  validates :title, presence: true
end

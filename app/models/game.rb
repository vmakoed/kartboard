class Game < ApplicationRecord
  has_many :contests, dependent: :destroy

  validates :title, presence: true
end

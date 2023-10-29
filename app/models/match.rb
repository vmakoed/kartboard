class Match < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  validates :code, presence: true, uniqueness: true, length: { is: 6 }
end

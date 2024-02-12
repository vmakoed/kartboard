class Contest < ApplicationRecord
  has_many :contestants, dependent: :destroy
  has_many :users, through: :contestants
end

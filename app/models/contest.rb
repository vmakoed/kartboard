class Contest < ApplicationRecord
  has_many :contestants, dependent: :destroy
  has_many :users, through: :contestants

  accepts_nested_attributes_for :contestants
end

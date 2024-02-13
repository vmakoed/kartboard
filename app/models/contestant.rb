class Contestant < ApplicationRecord
  PLACES = 1..4

  belongs_to :contest
  belongs_to :user
  has_one :score_log, dependent: :destroy

  validates :user, uniqueness: { scope: :contest }
  validates :place, inclusion: { in: PLACES }

  accepts_nested_attributes_for :score_log
  accepts_nested_attributes_for :user, update_only: true
end

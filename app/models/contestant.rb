class Contestant < ApplicationRecord
  PLACES = 1..4

  belongs_to :contest
  belongs_to :user
  has_one :score_log, dependent: :destroy

  accepts_nested_attributes_for :score_log
  accepts_nested_attributes_for :user, update_only: true  # FIXME: probably not a good idea but allows to save everything in a single call

  validates :user, uniqueness: { scope: :contest }
  validates :place, inclusion: { in: PLACES }
end

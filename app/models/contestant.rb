class Contestant < ApplicationRecord
  belongs_to :contest
  belongs_to :user
  has_one :score_log, dependent: :destroy

  validates :user, uniqueness: { scope: :contest }
end

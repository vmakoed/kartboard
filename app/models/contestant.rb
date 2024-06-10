class Contestant < ApplicationRecord
  PLACES = 1..4

  belongs_to :contest
  belongs_to :user, optional: true # TODO: remove after player backfill
  belongs_to :player, optional: true # TODO: remove optional after backfill
  has_one :score_log, dependent: :destroy

  accepts_nested_attributes_for :score_log
  accepts_nested_attributes_for :player

  validates :place, inclusion: { in: PLACES }

  scope :for_game, ->(game) { joins(:contest).where(contests: { game: game }) }
end

class Run < ApplicationRecord
  include AASM

  MINIMUM_PLAYERS = 2
  CODE_LENGTH = 6

  has_many :players, dependent: :destroy
  has_many :users, through: :players

  validates :code, presence: true, uniqueness: true, length: { is: CODE_LENGTH }

  after_initialize :set_defaults

  aasm do
    state :created, initial: true
    state :started
    state :finished

    event :start, after_commit: :update_actions do
      transitions from: :created,
                  to: :started,
                  guard: :enough_players?

    end

    event :finish, after_commit: :update_status_action do
      transitions from: :started,
                  to: :finished,
                  guard: :positions_complete?
    end
  end

  def players_stream_id
    "run_#{id}_players"
  end

  private

  def set_defaults
    self.code ||= SecureRandom.alphanumeric(6).upcase
  end

  def enough_players?
    players.count >= MINIMUM_PLAYERS
  end

  def positions_complete?
    !players.where(position: nil).exists?
  end

  def update_actions
    update_status_action
    update_user_action
  end

  def update_status_action
    broadcast_update_to self,
                        partial: "runs/status_action",
                        target: "run_status_action",
                        locals: { run: self } # TODO: use RunView?
  end

  def update_user_action
    broadcast_update_to self,
                        partial: "runs/user_action",
                        target: "run_user_action",
                        locals: { run: self } # TODO: use RunView?
  end
end

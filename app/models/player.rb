class Player < ApplicationRecord
  MIN_POSITION = 1
  MAX_POSITION = 12

  belongs_to :run
  belongs_to :user

  validates :position,
            numericality: {
              greater_than_or_equal_to: MIN_POSITION,
              less_than_or_equal_to: MAX_POSITION
            },
            uniqueness: { scope: :run_id },
            allow_blank: true

  # TODO: refactor with broadcasts_to?
  # TODO: remove from model?

  after_create_commit -> { broadcast_run_updates }
  after_update_commit -> { broadcast_run_updates }
  after_destroy_commit -> { broadcast_run_updates }

  def broadcast_run_updates
    update_players_list
    update_status_action
  end

  def update_players_list
    broadcast_update_to run,
                        partial: "players/list",
                        target: "players",
                        locals: { run: run }
  end

  def update_status_action
    broadcast_update_to run,
                        partial: "runs/status_action",
                        target: "run_status_action",
                        locals: { run: run }
  end
end

class Player < ApplicationRecord
  belongs_to :run
  belongs_to :user

  after_create_commit -> { update_players_list }
  after_destroy_commit -> { update_players_list }

  def update_players_list
    broadcast_update_to "run_#{run.id}_players",
                        partial: "players/list",
                        target: "players",
                        locals: { run: run }
  end
end

# frozen_string_literal: true

class AssignContestsToGame < ActiveRecord::Migration[7.1]
  GAME_TITLE = "Mario Kart"

  def up
    return unless Game.exists?(title: GAME_TITLE)

    Contest.where(game_id: nil).update_all(game_id: game.id)
  end

  def down
    return unless Game.exists?(title: GAME_TITLE)

    game.contests.update_all(game_id: nil)
  end

  private

  def game
    @game ||= Game.find_by!(title: GAME_TITLE)
  end
end

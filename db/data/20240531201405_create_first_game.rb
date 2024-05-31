# frozen_string_literal: true

class CreateFirstGame < ActiveRecord::Migration[7.1]
  GAME_TITLE = "Mario Kart"

  def up
    Game.create!(title: GAME_TITLE)
  end

  def down
    Game.find_by(title: GAME_TITLE)&.destroy
  end
end

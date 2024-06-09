# frozen_string_literal: true

class CreateMoreGames < ActiveRecord::Migration[7.1]
  GAMES = %w[
    Ping-Pong
    Darts
    Pool
  ]

  def up
    GAMES.each do |title|
      Game.create!(title: title)
    end
  end

  def down
    Game.where(name: GAMES).destroy_all
  end
end

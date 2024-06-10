# frozen_string_literal: true

class BackfillContestantPlayers < ActiveRecord::Migration[7.1]
  def up
    Contestant.find_each do |contestant|
      player = Player.find_by(game: contestant.contest.game, user: contestant.user)
      contestant.update!(player: player)
    end
  end

  def down
    Contestant.find_each do |contestant|
      contestant.update!(player: nil)
    end
  end
end

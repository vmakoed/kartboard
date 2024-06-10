# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.1]
  def up
    User.find_each do |user|
      Game
        .joins(contestants: :user)
        .where(users: { id: user.id })
        .distinct
        .find_each do |game|
          player = Player.find_or_initialize_by(user: user, game: game)
          player.score = user.score
          player.save!
        end
    end
  end

  def down
    Player.destroy_all
  end
end

class BoardsController < ApplicationController

  def show
    @players = Player
      .where(game: @current_game)
      .order('players.score DESC')
      .includes(:user)
      .distinct
  end
end

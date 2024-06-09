class CurrentGamesController < ApplicationController
  def update
    session[:current_game_id] = params[:game_id]

    redirect_to root_path
  end
end

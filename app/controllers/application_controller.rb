class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_game

  def set_current_game
    @current_game = if session[:current_game_id]
      Game.find(session[:current_game_id])
    else
      current_game
    end
  end

  private

  def current_game
    if current_user.nil?
      default_game
    else
      (current_user.last_played_game || default_game)
        .tap(&method(:assign_to_session))
    end
  end

  def default_game
     Game.first
  end

  def assign_to_session(game)
    session[:current_game_id] ||= game.id
  end
end

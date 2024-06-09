class BoardsController < ApplicationController
  def show
    puts @current_game
    @users = User
               .with_contestants
               .merge(Contestant.for_game(@current_game))
               .order(score: :desc)
  end
end

class BoardsController < ApplicationController
  def show
    @users = User.with_contestants.order(score: :desc)
  end
end

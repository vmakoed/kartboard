class BoardsController < ApplicationController
  def show
    @users = User.order(score: :desc)
  end
end

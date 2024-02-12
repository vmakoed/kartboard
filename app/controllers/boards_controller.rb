class BoardsController < ActionController::Base
  def show
    @users = User.order(score: :desc)
  end
end

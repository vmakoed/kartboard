class MatchesController < ActionController::Base
  def create
    @match = Match.create

    redirect_to match_path(@match)
  end

  def show
    @match = Match.find(params[:id])
  end
end

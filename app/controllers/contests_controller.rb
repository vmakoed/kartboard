class ContestsController < ActionController::Base
  def new
    @contest = Contest.new

    Contestant::PLACES.each do |place|
      @contest.contestants.build(place: place)
    end
  end

  def create
    @contest = Contests::Build.call(contest_params: contest_params)

    if @contest.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def contest_params
    params.require(:contest).permit(contestants_attributes: [:place, :user_id])
  end
end

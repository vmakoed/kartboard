class ContestsController < ApplicationController
  def index
    @contests = Contest
      .for_game(@current_game)
      .order(created_at: :desc)
      .limit(25)
      .includes(contestants: [:user, :score_log])
      .map(&Contests::View.method(:new))
  end
  def new
    @contest = Contest.new
    @game = Games::View.new(@current_game)

    Contestant::PLACES.each do |place|
      @contest.contestants.build(place: place)
    end
  end

  def create
    @contest = Contests::Build.call(
      contest_params: contest_params.merge(
        game: @current_game,
        created_by: current_user
      )
    )

    if @contest.save
      redirect_to contest_path(@contest)
    else
      @game = Games::View.new(@current_game)
      build_contestants

      render :new, status: :unprocessable_entity
    end
  end

  def show
    @contestants = Contest
      .find(params[:id])
      .contestants
      .includes(:user, :score_log)
      .map(&Contestants::View.method(:new))
  end

  private

  def contest_params
    params.require(:contest).permit(contestants_attributes: [:place, :user_id])
  end

  def build_contestants # TODO: move to a service
    all_places = Contestant::PLACES.to_a

    needed_contestants = all_places.size - @contest.contestants.size
    return if needed_contestants <= 0

    taken_places = @contest.contestants.map(&:place).uniq
    available_places = all_places - taken_places

    available_places.first(needed_contestants).each do |place|
      @contest.contestants.build(place: place)
    end

    @contest.contestants = @contest.contestants.sort_by do |contestant|
      [contestant.place, contestant.id || 0]
    end
  end
end

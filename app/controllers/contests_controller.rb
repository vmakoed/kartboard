class ContestsController < ApplicationController
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
      build_contestants

      render :new, status: :unprocessable_entity
    end
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

    @contest.contestants = @contest.contestants.sort_by { |contestant| [contestant.place, contestant.id || 0] }
  end
end

class ParticipantsController < ActionController::Base
  before_action :authenticate_user!

  def new; end

  def create
    @match = Match.find(params[:match_id])
    @participant = Participant.create(
      match: @match,
      user: current_user
    )

    redirect_to edit_match_participant_path(@match, @participant)
  end

  def edit
    @match = Match.find(params[:match_id])
    @participant = Participant.find(params[:id])
  end

  def update
    @participant = Participant.find(params[:id])
    @participant.update!(participant_params)

    redirect_to match_path(Match.find(params[:match_id]))
  end

  private

  def participant_params
    params.require(:participant).permit(:position)
  end
end

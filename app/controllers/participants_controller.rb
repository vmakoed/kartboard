class ParticipantsController < ApplicationController
  before_action :authenticate_user!

  def create
    @match = Match.find_or_create_by(code: params[:match_code])
    Participant.create(
      match: @match,
      user: current_user
    )

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def participant_params
    params.require(:participant).permit(:position)
  end
end

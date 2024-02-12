class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_run, only: [:create, :edit, :update, :destroy]
  before_action :set_player, only: [:edit, :update, :destroy]

  def create
    @player = @run.players.build(user: current_user)
    @player.save

    respond_to do |format|
      format.html { redirect_to run_path(@run) }
      format.turbo_stream
    end
  end

  def edit; end

  def update
    if @player.update(player_params)
      redirect_to @run
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @player.destroy

    respond_to do |format|
      format.html { redirect_to run_path(@run) }
      format.turbo_stream
    end
  end

  private

  def set_run
    @run = Run
      .find(params[:run_id])
      .then { |record|
        RunView.new(
         run: record,
         current_user: current_user
        )
      }
  end

  def set_player
    @player = @run.players.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:position)
  end
end
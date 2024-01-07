class RunsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_run, only: [:show, :destroy, :start, :finish]

  def index
    @runs = Run.all
  end

  def show
    @run = RunView.new(run: @run, current_user: current_user)
  end

  def create
    @run = Run.new
    @run.save!

    redirect_to run_path(@run)
  end

  def destroy
    @run.destroy

    redirect_to runs_path
  end

  def start
    @run.start!
  end

  def finish
    @run.finish!
  end

  private

  def set_run
    @run = Run.find(params[:id])
  end
end

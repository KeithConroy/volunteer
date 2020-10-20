class SchedulesController < ApplicationController
  before_action :find_schedule, except: [:index, :new]
  before_action :find_selections, only: [:new, :edit]

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.create!(schedule_params)
    redirect_to @schedule
  end

  def destroy
  end

  private

  def find_schedule
    @schedule = Schedule.find(params[:id])
  end

  def find_selections
    @types = @organization.shift_types.pluck(:name, :id)
  end

  def schedule_params
    params.require(:schedule).permit(
      :organization_id,
      :shift_type_id,
      :spots,
      :start_date,
      :end_date,
      :start_time,
      :end_time,
      :frequency,
      :frequency_data
    )
  end

end

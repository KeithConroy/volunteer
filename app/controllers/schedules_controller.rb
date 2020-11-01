class SchedulesController < ApplicationController
  before_action :find_schedule, except: [:index, :new]
  before_action :find_selections, only: [:new, :edit]
  before_action :authorize_admin!, except: [:new]

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
    @types = current_user.admin_organization.shift_types.pluck(:name, :id)
    @frequencies = Schedule::FREQUENCIES
    @days_out = [['One Week', 7], ['One Month', 30], ['Three Months', 90]]
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
      :frequency_data,
      :days_out,
    )
  end

  def requested_org_id
    params.dig(:schedule, :organization_id) || @schedule.organization_id
  end

end

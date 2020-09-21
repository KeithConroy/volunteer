class ShiftsController < ApplicationController
  before_action :find_shift, except: [:search_index, :index, :new]
  before_action :find_organization
  before_action :find_selections, only: [:new, :edit]

  def search_index
    @organization = nil
    @available_only = nil

    org_ids = if params[:organization_id]
      unless @current_user.has_access?(params[:organization_id])
        flash[:info] = 'Page not found'
        redirect_back(fallback_location: root_path)
      end

      @organization = Organization.find(params[:organization_id])
      params[:organization_id]
    else
      @current_user.user_organizations.approved.pluck(:organization_id)
    end

    shift_type_ids = ShiftType.where(
      organization_id: org_ids,
      role_id: [@current_user.user_roles.pluck(:role_id)] + [nil]
    ).pluck(:id)

    shifts = Shift.scheduled.where(shift_type_id: shift_type_ids)
    if params[:available_only]
      @available_only = true
      shifts = shifts.available
    else

    end

    @shifts = shifts.order(:starts_at)
  end

  def index
    shifts = Shift.for_current_organization.order(:starts_at)
    @scheduled_shifts = shifts.scheduled
    @completed_shifts = shifts.completed
  end

  def show
  end

  def edit
  end

  def update
    if @shift.update_attributes(shift_params)
      flash[:info] = "Shift updated"
      redirect_to @shift
    else
      # render json: @shift.errors.full_messages, status: 400
    end
  end

  def new
    @shift = Shift.new
  end

  def create
    case params[:frequency]
    when 'recurring'
      # create multiple
    else
      @shift = Shift.create!(shift_params)
      redirect_to @shift
    end
  end

  def sign_up
    unless @shift.remaining_spots.positive?
      flash[:error] = 'Shift is full'
      redirect_back(fallback_location: root_path)
    end

    if @shift.users.include?(@current_user)
      flash[:error] = 'You have already signed up for this shift'
      redirect_back(fallback_location: root_path)
    end

    UserShift.create(
      shift: @shift,
      user: @current_user
    )
    UserMailer.shift_confirmation(@current_user, @shift).deliver_later

    redirect_back(fallback_location: root_path)
  end

  def user_cancel
    @shift.user_shifts.where(user_id: @current_user.id).destroy_all
    UserMailer.shift_cancellation(@current_user, @shift).deliver_later

    flash[:info] = 'Shift cancelled'
    redirect_back(fallback_location: root_path)
  end

  def admin_cancel
    had_volunteers = false
    @shift.user_shifts.each do |user_shift|
      had_volunteers = true
      # notify user
      user_shift.destroy
    end
    @shift.destroy
    flash[:info] = "Shift has been cancelled#{', volunteers have been notified' if had_volunteers}"
    redirect_to(action: 'index')
  end

  private

  def find_shift
    @shift = Shift.find(params[:id])
  end

  def find_organization
    @organization = Organization.find(1)
  end

  def find_selections
    @types = @organization.shift_types.pluck(:name, :id)
  end

  def shift_params
    params.require(:shift).permit(:shift_type_id, :spots, :starts_at, :ends_at)
  end
end

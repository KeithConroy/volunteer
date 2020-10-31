class ShiftsController < ApplicationController
  before_action :find_shift, except: [:search, :index, :new]
  before_action :find_selections, only: [:new, :edit]

  def search
    # params[:organization_ids]
    # params[:shift_type_ids]
    # params[:available_only]
    # params[:day_ids]

    @days = [['Any', -1], ['Sunday', 0],['Monday', 1], ['Tuesday', 2], ['Wednesday', 3], ['Thursday', 4], ['Friday', 5], ['Saturday', 6]]
    @my_organizations = [["All", 0]]
    @my_organization_shift_types = [["All", 0]]
    current_user.organizations.map do |org|
      @my_organizations << [org.name, org.id]
      org.shift_types.each do |type|
        @my_organization_shift_types << [type.name, type.id]
      end
    end

    org_ids = if params[:organization_ids].present? && params[:organization_ids][0].to_i.positive?
      @my_organization_shift_types = [["All", nil]]
      current_user.organizations.where(id: params[:organization_ids]).map do |org|
        org.shift_types.each do |type|
          @my_organization_shift_types << [type.name, type.id]
        end
      end
      current_user.user_organizations.approved.where(organization_id: params[:organization_ids]).pluck(:organization_id)
    else
      current_user.user_organizations.approved.pluck(:organization_id)
    end

    if params[:shift_type_ids].present? && params[:shift_type_ids][0].to_i.positive?
      shift_type_ids = ShiftType.where(
        organization_id: org_ids,
        id: params[:shift_type_ids],
        role_id: [current_user.user_roles.pluck(:role_id)] + [nil]
      ).pluck(:id)
    else
      shift_type_ids = ShiftType.where(
        organization_id: org_ids,
        role_id: [current_user.user_roles.pluck(:role_id)] + [nil]
      ).pluck(:id)
    end

    @shifts = Shift.scheduled.where(shift_type_id: shift_type_ids).order(:date)

    if params[:available_only]
      @shifts = @shifts.available
    end

    if params[:day_ids].present? && params[:day_ids][0].to_i >= 0
      @shifts = @shifts.select{|s| params[:day_ids].include?(s.date.wday.to_s) }
    end

    if params[:hide_my_shifts]
      @shifts = @shifts.reject{|s| s.users.include?(current_user) }
    end

    @organization_ids = params[:organization_ids] || 0
    @shift_type_ids = params[:shift_type_ids] || 0
    @day_ids = params[:day_ids] || -1
    @available_only = params[:available_only] || false
    @hide_my_shifts = params[:hide_my_shifts] || false
  end

  def index
    @shifts = Shift.for_current_organization.order(:date)
    @shift_types = [["All", 0]]

    @organization.shift_types.each do |type|
      @shift_types << [type.name, type.id]
    end

    if params[:shift_type_ids] && params[:shift_type_ids][0].to_i.positive?
      @shifts = @shifts.where(shift_type_id: params[:shift_type_ids])
    end

    @shift_type_ids = params[:shift_type_ids] || 0
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
    @shift = Shift.create!(shift_params)
    redirect_to @shift
  end

  def sign_up
    unless @shift.remaining_spots.positive?
      flash[:danger] = 'Shift is full'
      redirect_back(fallback_location: authenticated_root_path)
      return
    end

    if @shift.users.include?(current_user)
      flash[:danger] = 'You have already signed up for this shift'
      redirect_back(fallback_location: authenticated_root_path)
      return
    end

    UserShift.create(
      shift: @shift,
      user: current_user
    )
    UserMailer.shift_confirmation(current_user, @shift).deliver_later

    redirect_back(fallback_location: authenticated_root_path)
  end

  def user_cancel
    @shift.user_shifts.where(user_id: current_user.id).destroy_all
    UserMailer.shift_cancellation(current_user, @shift).deliver_later

    flash[:info] = 'Shift cancelled'
    redirect_back(fallback_location: authenticated_root_path)
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
    redirect_to manage_organization_path(@organization)
  end

  private

  def find_shift
    @shift = Shift.find(params[:id])
  end

  def find_selections
    @types = @organization.shift_types.pluck(:name, :id)
  end

  def shift_params
    params.require(:shift).permit(:organization_id, :shift_type_id, :spots, :date, :start_time, :end_time)
  end
end

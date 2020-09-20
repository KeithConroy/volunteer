class ShiftsController < ApplicationController
  before_action :find_shift, only: [:show, :sign_up, :edit, :update]
  before_action :find_organization
  before_action :find_selections, only: [:new, :edit]

  def index
    @shifts = Shift.all.order(:starts_at)
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

    else
      @shift = Shift.create!(shift_params)
      redirect_to @shift
    end
  end

  def sign_up
    unless @shift.remaining_slots.positive?
      flash[:error] = 'Shift is full'
      redirect_back(fallback_location: root_path)
    end

    if @shift.users.include?(User.first)
      flash[:error] = 'You have already signed up for this shift'
      redirect_back(fallback_location: root_path)
    end

    UserShift.create(
      shift: @shift,
      user: User.first
    )
    redirect_back(fallback_location: root_path)
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
    @addresses = @organization.addresses.pluck(:line_1, :id)
  end

  def shift_params
    params.require(:shift).permit(:shift_type_id, :slots, :address_id, :starts_at, :ends_at)
  end
end

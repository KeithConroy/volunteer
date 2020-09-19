class ShiftsController < ApplicationController
  before_action :find_shift, only: [:show, :sign_up]
  before_action :find_organization

  def index
    @shifts = Shift.all
  end

  def show
  end

  def new
    @shift = Shift.new
    @types = @organization.shift_types.pluck(:name, :id)
    @addresses = @organization.addresses.pluck(:line_1, :id)
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
      redirect_to :back
    end

    if @shift.users.include?(User.first)
      flash[:error] = 'You have already signed up for this shift'
      redirect_to :back
    end

    UserShift.create(
      shift: @shift,
      user: User.first
    )
    redirect_to @shift
  end

  private

  def find_shift
    @shift = Shift.find(params[:id])
  end

  def find_organization
    @organization = Organization.find(1)
  end

  def shift_params
    params.require(:shift).permit(:shift_type_id, :slots, :address_id, :starts_at, :ends_at)
  end
end

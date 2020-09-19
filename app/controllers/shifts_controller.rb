class ShiftsController < ApplicationController

  def index
    @shifts = Shift.all
  end

  def show
    @shift = Shift.find(params[:id])
  end

  def new
    @shift = Shift.new
    @types = ShiftType.all.pluck(:name, :id)
  end

  def sign_up
    instance = Shift.find(params[:id])
    UserShift.create(
      shift: instance,
      user: User.first
    )
  end
end

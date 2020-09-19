class ShiftTypesController < ApplicationController
  before_action :find_shift_type, only: [:show]

  def index
    @types = ShiftType.all
  end

  def show
  end

  def new
    @type = ShiftType.new
  end

  def create
    @type = ShiftType.new(shift_type_params)

    if @type.save!
      redirect_to @type
    else
      redirect_to :back
    end
  end

  private

  def find_shift_type
    @type = ShiftType.find(params[:id])
  end

  def shift_type_params
    params.require(:shift_type).permit(:name, :description, :organization_id)
  end
end

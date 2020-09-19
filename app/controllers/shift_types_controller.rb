class ShiftTypesController < ApplicationController
  before_action :find_shift_type, only: [:show, :edit, :update]

  def index
    @types = ShiftType.all
  end

  def show
  end

  def edit
  end

  def update
    if @type.update_attributes(shift_type_params)
      flash[:info] = "Shift Type updated"
      redirect_to @type
    else
      # render json: @type.errors.full_messages, status: 400
    end
  end

  def new
    @type = ShiftType.new
  end

  def create
    @type = ShiftType.new(shift_type_params)

    if @type.save!
      redirect_to @type
    else
      redirect_back(fallback_location: root_path)
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

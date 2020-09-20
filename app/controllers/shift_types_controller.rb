class ShiftTypesController < ApplicationController
  before_action :find_shift_type, only: [:show, :edit, :update, :destroy]
  before_action :find_organization
  before_action :find_selections, only: [:new, :edit]

  def index
    @shift_types = ShiftType.where(organization_id: @current_user.admin_organization&.id)
  end

  def show
  end

  def edit
  end

  def update
    if @shift_type.update_attributes(shift_type_params)
      flash[:info] = "Shift Type updated"
      redirect_back(fallback_location: root_path)
    else
      # render json: @shift_type.errors.full_messages, status: 400
    end
  end

  def new
    @shift_type = ShiftType.new
  end

  def create
    @shift_type = ShiftType.new(shift_type_params)

    if @shift_type.save!
      redirect_to @shift_type
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @shift_type.destroy
    redirect_to(action: 'index')
  end

  private

  def find_shift_type
    @shift_type = ShiftType.find(params[:id])
  end

  def find_organization
    @organization = Organization.find(1)
  end

  def find_selections
    @addresses = @organization.addresses.pluck(:line_1, :id)
    @roles = @organization.roles.pluck(:name, :id)
  end

  def shift_type_params
    params.require(:shift_type).permit(:name, :description, :organization_id, :address_id)
  end
end
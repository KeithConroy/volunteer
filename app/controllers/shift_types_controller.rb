class ShiftTypesController < ApplicationController
  before_action :find_shift_type, only: [:show, :edit, :update, :destroy]
  before_action :find_selections, only: [:new, :edit]
  before_action :authorize_admin!, except: [:new]

  def index
    @shift_types = ShiftType.for_current_organization
  end

  def show
  end

  def edit
  end

  def update
    if @shift_type.update_attributes(shift_type_params)
      flash[:info] = "Shift Type updated"
      redirect_back(fallback_location: authenticated_root_path)
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
      redirect_back(fallback_location: authenticated_root_path)
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

  def find_selections
    @addresses = Address.for_current_organization.pluck(:line_1, :id)
    @roles = Role.for_current_organization.pluck(:name, :id)
  end

  def shift_type_params
    params.require(:shift_type).permit(:name, :description, :organization_id, :address_id, :role_id)
  end

  def requested_org_id
    params.dig(:shift_type, :organization_id) || @shift_type.organization_id
  end

end

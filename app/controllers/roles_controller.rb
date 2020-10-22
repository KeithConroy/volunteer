class RolesController < ApplicationController
  before_action :find_role, only: [:show, :edit, :update, :destroy]

  def index
    @roles = Role.where(organization_id: current_user.admin_organization&.id)
  end

  def show
  end

  def edit
  end

  def update
    if @role.update_attributes(role_params)
      flash[:info] = "Role updated"
      redirect_back(fallback_location: root_path)
    else
      # render json: @role.errors.full_messages, status: 400
    end
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)

    if @role.save!
      redirect_to @role
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @role.destroy
    redirect_to(action: 'index')
  end

  private

  def find_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :description, :organization_id)
  end
end

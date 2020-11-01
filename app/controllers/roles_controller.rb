class RolesController < ApplicationController
  before_action :find_role, only: [:show, :edit, :update, :destroy, :assign_role, :remove_role]
  before_action :authorize_admin!, except: [:new]

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
      redirect_back(fallback_location: authenticated_root_path)
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
      redirect_back(fallback_location: authenticated_root_path)
    end
  end

  def destroy
    @role.destroy
    redirect_to(action: 'index')
  end

  def assign_user
    @user = User.find(params[:user_id])
    UserRole.create(user_id: @user.id, role_id: @role.id)
    # UserMailer.role_assigned(@user, @role).deliver_later

    flash[:info] = "#{@role.name} role assigned to #{@user.full_name}"
    redirect_back(fallback_location: authenticated_root_path)
  end

  def remove_user
    @user = User.find(params[:user_id])
    UserRole.where(user_id: @user.id, role_id: @role.id).first.destroy
    # notify user
    flash[:info] = "#{@role.name} role removed from #{@user.full_name}"
    redirect_back(fallback_location: authenticated_root_path)
  end

  private

  def find_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :description, :organization_id)
  end

  def requested_org_id
    params.dig(:role, :organization_id) || @role.organization_id
  end
end

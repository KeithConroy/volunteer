class UsersController < ApplicationController
  before_action :find_user, only: [:show, :assign_role, :remove_role]
  before_action :find_role, only: [:assign_role, :remove_role]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def assign_role
    UserRole.create(user_id: @user.id, role_id: @role.id)
    # notify user
    flash[:info] = "#{@role.name} role assigned to #{@user.full_name}"
    redirect_back(fallback_location: root_path)
  end

  def remove_role
    UserRole.where(user_id: @user.id, role_id: @role.id).first.destroy
    # notify user
    flash[:info] = "#{@role.name} role removed from #{@user.full_name}"
    redirect_back(fallback_location: root_path)
  end

  private

  def find_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def find_role
    @role = Role.find(params[:role_id])
  end

end

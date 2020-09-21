class UsersController < ApplicationController
  before_action :find_user, except: [:index]
  before_action :find_role, only: [:assign_role, :remove_role]

  def index
    users = User.for_current_organization
    user_orgs = UserOrganization.for_current_organization.where(user_id: users.pluck(:id))
    @pending_users = users.where(id: user_orgs.where(status: :pending).pluck(:user_id))
    @users = users - @pending_users
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

  def my_organizations
    @user_organizations = @user.user_organizations.order(:status)
  end

  def my_shifts
    @scheduled_shifts = @user.shifts.scheduled
    @completed_shifts = @user.shifts.completed
  end

  private

  def find_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def find_role
    @role = Role.find(params[:role_id])
  end

end

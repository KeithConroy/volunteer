class UsersController < ApplicationController
  before_action :find_user, except: [:index, :sign_out]
  before_action :check_user_authorization, only: [:profile]
  before_action :check_admin_authorization, only: [:show]

  def index
    users = User.for_current_organization
    user_orgs = UserOrganization.for_current_organization.where(user_id: users.pluck(:id))
    @pending_users = users.where(id: user_orgs.where(status: :pending).pluck(:user_id))
    @users = users - @pending_users
  end

  def show
  end

  def profile
    @user_organizations = @user.user_organizations.order(:status)
    @scheduled_shifts = @user.shifts.scheduled.order(:date, :start_time)
    @completed_shifts = @user.shifts.completed.order(:date, :start_time)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def check_user_authorization
    raise ActionController::RoutingError.new('Not Found') unless current_user == @user
  end

  def check_admin_authorization
    org = current_user.admin_organization
    raise ActionController::RoutingError.new('Not Found') unless org && org.users.where(id: params[:id]).present?
  end

end

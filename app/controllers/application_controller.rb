class ApplicationController < ActionController::Base
  before_action :find_current_user

  def find_current_user
    @current_user = User.first
    @organization = @current_user.admin_organization
    Thread.current[:organization_id] = @current_user.admin_organization&.id
  end
end

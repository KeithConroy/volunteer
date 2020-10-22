class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :find_current_user

  def find_current_user
    # current_user = User.first
    if current_user
      @organization = current_user.admin_organization
      Thread.current[:organization_id] = current_user.admin_organization&.id
    end
  end
end

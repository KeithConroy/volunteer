class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_organization

  def set_organization
    if current_user
      @organization = current_user.admin_organization
      Thread.current[:organization_id] = current_user.admin_organization&.id
    end
  end
end

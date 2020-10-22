class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def landing
    if current_user.admin_organization.present?
      redirect_to manage_organization_path(current_user.admin_organization)
    else
      redirect_to profile_user_path(current_user)
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_organization
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_organization
    if current_user
      @organization = current_user.admin_organization
      Thread.current[:organization_id] = current_user.admin_organization&.id
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password) }
  end
end

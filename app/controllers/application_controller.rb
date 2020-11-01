class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_organization
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_organization
    Thread.current[:organization_id] = current_user&.admin_organization&.id
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password) }
  end

  def requested_org_id
    raise NotImplementedError.new
  end

  def authorize_admin!
    return unless requested_org_id.present?
    raise ActionController::RoutingError.new('Not Found') unless @current_user.organization_admins.where(organization_id: requested_org_id).present?
  end
end

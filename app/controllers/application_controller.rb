class ApplicationController < ActionController::Base
  before_action :find_current_user

  def find_current_user
    @current_user = User.first
  end
end

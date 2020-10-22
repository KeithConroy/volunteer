class OrganizationsController < ApplicationController
  before_action :find_organization, except: [:new, :index, :create, :search]
  before_action :authenticate_admin, except: [:new, :index, :create, :search, :request_access]

  def manage
    users = User.for_current_organization
    user_orgs = UserOrganization.for_current_organization.where(user_id: users.pluck(:id))
    @pending_users = users.where(id: user_orgs.where(status: :pending).pluck(:user_id))
    @users = users - @pending_users
  end

  # def change_tab
  #   case params[:tab]
  #   when 'details'
  #     render :'organizations/manage/_details', layout: false
  #   when 'admins'
  #     render :'organizations/manage/_admins', layout: false
  #   when 'roles'
  #     render :'organizations/manage/_roles', layout: false
  #   when 'shift_types'
  #     render :'organizations/manage/_shift_types', layout: false
  #   when 'shifts'
  #     render :'organizations/manage/_shifts', layout: false
  #   when 'volunteers'
  #     users = User.for_current_organization
  #     user_orgs = UserOrganization.for_current_organization.where(user_id: users.pluck(:id))
  #     @pending_users = users.where(id: user_orgs.where(status: :pending).pluck(:user_id))
  #     @users = users - @pending_users
  #     render :'organizations/manage/_volunteers', layout: false
  #   end
  # end

  def search
    if params[:hide_my_organizations]
      @organizations = Organization.where.not(id: current_user.user_organizations.pluck(:organization_id))
    else
      @organizations = Organization.all
    end

    @radii = [10,25,50]
    @radius = params[:radius] || 50
    @hide_my_organizations = params[:hide_my_organizations] || false
  end

  def index
    @organizations = Organization.all
  end

  def show
  end

  def edit
  end

  def update
    if @organization.update_attributes(organization_params)
      flash[:info] = "Organization updated"
      redirect_to @organization
    else

    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    OrganizationAdmin.create(user: current_user, organization: @organization)

    if @organization.save
      redirect_to @organization
    else

    end
  end

  def request_access
    user_org = UserOrganization.create(
      organization_id: @organization.id,
      user_id: params[:user_id],
      status: :pending
    )

    if @organization.requires_approval
      flash[:info] = "Request has been submitted"
    else
      user_org.update(status: :approved)
      flash[:info] = "Access Granted"
    end

    redirect_back(fallback_location: authenticated_root_path)
  end

  def grant_access
    user_org = UserOrganization.where(
      organization_id: @organization.id,
      user_id: params[:user_id],
    ).first

    user_org.update(status: :approved)
    flash[:info] = "Access Granted"
    redirect_back(fallback_location: authenticated_root_path)
  end

  def deny_access
    user_org = UserOrganization.where(
      organization_id: @organization.id,
      user_id: params[:user_id],
    ).first

    user_org.destroy
    flash[:info] = "Access Denied"
    redirect_back(fallback_location: authenticated_root_path)
  end

  def ban_user
    user_org = UserOrganization.where(
      organization_id: @organization.id,
      user_id: params[:user_id],
    ).first

    user_org.update(status: :banned)

    UserRole.where(
      user_id: params[:user_id],
      role_id: @organization.roles.pluck(:id)
    ).destroy_all

    shift_ids = Shift.scheduled.where(organization_id: @organization.id).pluck(:id)

    UserShift.where(
      user_id: params[:user_id],
      shift_id: shift_ids
    ).destroy_all

    flash[:info] = "User Banned"
    redirect_back(fallback_location: authenticated_root_path)
  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :url, :requires_approval)
  end

  def authenticate_admin
    raise 'Unauthorized' unless @organization.organization_admins.where(user_id: current_user.id).present?
  end

end

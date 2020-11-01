class OrganizationsController < ApplicationController
  before_action :find_organization, except: [:new, :index, :create, :search]
  before_action :authorize_admin!, except: [:new, :index, :search, :request_access]

  def manage
    users = User.for_current_organization
    user_orgs = UserOrganization.for_current_organization.where(user_id: users.pluck(:id))
    @pending_users = users.where(id: user_orgs.where(status: :pending).pluck(:user_id))
    @users = users - @pending_users
  end

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
      redirect_to manage_organization_path(@organization)
    else

    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      @organization.make_admin(current_user)
      @organization.approve_user(current_user)

      redirect_to manage_organization_path(@organization)
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
    user = User.find(params[:user_id])
    @organization.approve_user(user)

    UserMailer.access_granted(user, @organization).deliver_later

    flash[:info] = "Access Granted to #{user.full_name}"
    redirect_back(fallback_location: authenticated_root_path)
  end

  def deny_access
    user_org = UserOrganization.where(
      organization_id: @organization.id,
      user_id: params[:user_id],
    ).first

    user_org.destroy
    flash[:info] = "Access Denied for #{user.full_name}"
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

  def make_admin
    user = User.find(params[:user_id])
    @organization.make_admin(user)
    flash[:info] = "Admin privileges granted to #{user.full_name}"
    redirect_back(fallback_location: authenticated_root_path)
  end

  def revoke_admin
    user = User.find(params[:user_id])
    @organization.organization_admins.where(user_id: user.id).destroy_all
    flash[:info] = "Admin privileges revoked for #{user.full_name}"
    redirect_back(fallback_location: authenticated_root_path)
  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :url, :requires_approval, :logo)
  end

  def requested_org_id
    params[:id]
  end

end

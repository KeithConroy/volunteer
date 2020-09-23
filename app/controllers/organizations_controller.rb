class OrganizationsController < ApplicationController
  before_action :find_organization, except: [:new, :index, :create]

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
    OrganizationAdmin.create(user: @current_user, organization: @organization)

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

    redirect_back(fallback_location: root_path)
  end

  def grant_access
    user_org = UserOrganization.where(
      organization_id: @organization.id,
      user_id: params[:user_id],
    ).first

    user_org.update(status: :approved)
    flash[:info] = "Access Granted"
    redirect_back(fallback_location: root_path)
  end

  def deny_access
    user_org = UserOrganization.where(
      organization_id: @organization.id,
      user_id: params[:user_id],
    ).first

    user_org.destroy
    flash[:info] = "Access Denied"
    redirect_back(fallback_location: root_path)
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
    redirect_back(fallback_location: root_path)
  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :url, :requires_approval)
  end

end

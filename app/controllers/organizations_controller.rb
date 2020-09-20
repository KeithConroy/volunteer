class OrganizationsController < ApplicationController
  before_action :find_organization, only: [:show, :edit, :update, :request_access]

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
    # create admin
    @current_user

    if @organization.save
      redirect_to @organization
    else

    end
  end

  def request_access
    user_org = UserOrganization.create(organization_id: @organization.id, user_id: params[:user_id])

    if @organization.requires_approval
      flash[:info] = "Request has been submitted"
    else
      user_org.update(is_approved: true)
      flash[:info] = "Access Granted"
    end

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

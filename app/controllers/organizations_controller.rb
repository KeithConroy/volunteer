class OrganizationsController < ApplicationController
  before_action :find_organization, only: [:show, :edit, :update]

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

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :url, :requires_approval)
  end

end

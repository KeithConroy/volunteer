class AddressesController < ApplicationController
  before_action :find_address, except: [:new, :create]
  before_action :authorize_admin!, except: [:new]

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      flash[:info] = 'Address saved'
      redirect_to @address
    else

    end
  end

  def show
  end

  def edit
  end

  def update
  end

  private

  def find_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:line_1, :line_2, :city, :state, :zip_code, :organization_id)
  end

  def requested_org_id
    params.dig(:address, :organization_id) || @address.organization_id
  end

end

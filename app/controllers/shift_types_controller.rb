class ShiftTypesController < ApplicationController

  def index
    @types = ShiftType.all
  end

  def show
    @type = ShiftType.find(params[:id])
  end

end

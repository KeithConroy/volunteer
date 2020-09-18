class ActivityInstancesController < ApplicationController

  def index
    @activities = ActivityInstance.all
  end

  def sign_up
    instance = ActivityInstance.find(params[:id])
    ActivitySlot.create(
      activity_instance: instance,
      user: User.first
    )
  end
end

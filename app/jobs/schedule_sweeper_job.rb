class ScheduleSweeperJob < ApplicationJob

  def perform
    # Schedule.where(frequency: :daily).or(frequency: :weekly, frequency_data like Date.today.strftime("%w"))

    Schedule.where("end_date > ?", Date.today).each do |schedule|
      ScheduleJob.perform_later(schedule)
    end
  end

end

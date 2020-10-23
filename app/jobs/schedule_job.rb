class ScheduleJob < ApplicationJob

  def perform(schedule)
    date = Date.today + (schedule.days_out + 1).days

    return if schedule.shifts.where(date: date).exists?

    if schedule.end_date.nil? || date <= schedule.end_date
      case schedule.frequency
      when :daily
      when :weekly
        # check frequency data
        # return unless schedule.frequency_data.inlcude?(date.strftime("%w"))
      end

      schedule.create_shift(date)
    end
  end

end

class ShiftReminderJob < ApplicationJob

  def perform
    upcoming_shifts = Shift.where(date: (Date.today + 1.day)..(Date.today + 2.days))

    upcoming_shifts.each do |shift|
      shift.users.each do |user|
        ShiftReminderJob.perform_later(shift, user)
      end
    end
  end

end

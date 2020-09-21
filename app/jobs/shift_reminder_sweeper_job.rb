class ShiftReminderJob < ApplicationJob

  def perform
    upcoming_shifts = Shift.where(starts_at: (DateTime.now + 1.day)..(DateTime.now + 2.days))

    upcoming_shifts.each do |shift|
      shift.users.each do |user|
        ShiftReminderJob.perform_later(shift, user)
      end
    end
  end

end

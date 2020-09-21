class ShiftReminderJob < ApplicationJob

  def perform(shift, user)
    UserMailer.shift_reminder(user, shift).deliver_later
  end

end

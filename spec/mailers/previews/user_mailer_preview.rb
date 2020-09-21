# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def shift_confirmation
    UserMailer.shift_confirmation(User.first, Shift.first)
  end

  def shift_cancellation
    UserMailer.shift_cancellation(User.first, Shift.first)
  end

  def shift_reminder
    UserMailer.shift_reminder(User.first, Shift.first)
  end

  def role_assigned
    UserMailer.role_assigned(User.first, Role.first)
  end

end

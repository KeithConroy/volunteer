class UserMailer < ApplicationMailer
  default from: 'notifications@volunteer.com'

  def shift_confirmation(user, shift)
    @user = user
    @shift = shift
    mail(to: @user.email, subject: 'Volunteer Shift Confirmation')
  end

  def shift_cancellation(user, shift)
    @user = user
    @shift = shift
    mail(to: @user.email, subject: 'Volunteer Shift Cancellation')
  end

  def shift_reminder(user, shift)
    @user = user
    @shift = shift
    mail(to: @user.email, subject: 'Volunteer Shift Reminder')
  end

  def role_assigned(user, role)
    @user = user
    @role = role
    mail(to: @user.email, subject: 'You have a new role')
  end

  def access_granted(user, organization)
    @user = user
    @organization = organization
    mail(to: @user.email, subject: 'You have a new organization')
  end

end

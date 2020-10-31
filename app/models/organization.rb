class Organization < ApplicationRecord
  has_many :shift_types
  has_many :shifts
  has_many :schedules
  has_many :addresses
  has_many :roles

  has_many :user_organizations
  has_many :users, through: :user_organizations

  has_many :organization_admins
  has_many :admins, through: :organization_admins, source: :user, class_name: 'User'

  has_one_attached :logo

  def top_volunteers
    UserShift.where(shift_id: shifts.pluck(:id))
      .group_by(&:user)
      .map{|k,v| [k, v.count]}
      .sort_by {|a| a[1]}
      .first(10)
      .to_h
  end

  def approve_user(user)
    user_org = user_organizations.where(user_id: user.id).first_or_initialize
    user_org.update(status: :approved)
  end

  def make_admin(user)
    organization_admins.create(
      user: user
    )
  end

end

class Organization < ApplicationRecord
  has_many :shift_types
  has_many :shifts
  has_many :addresses
  has_many :roles

  has_many :user_organizations
  has_many :users, through: :user_organizations

  has_many :organization_admins
  has_many :admins, through: :organization_admins, source: :user, class_name: 'User'

  def top_volunteers
    shifts.joins(:user_shifts)
      .group_by(&:users)
      .map{|k,v| [k.first, v.count]}
      .sort_by {|a| a[1]}
      .first(10)
      .to_h
  end

end

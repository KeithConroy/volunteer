class User < ApplicationRecord
  has_many :user_shifts
  has_many :shifts, through: :user_shifts

  has_many :user_roles
  has_many :roles, through: :user_roles

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin_organization
    # AdminUser.where(user_id: id).first&.organization
    Organization.first
  end
end

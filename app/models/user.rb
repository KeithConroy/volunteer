class User < ApplicationRecord
  has_many :user_shifts
  has_many :shifts, through: :user_shifts

  has_many :user_roles
  has_many :roles, through: :user_roles

  def full_name
    "#{first_name} #{last_name}"
  end
end

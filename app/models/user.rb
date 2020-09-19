class User < ApplicationRecord
  has_many :user_shifts
  has_many :shifts, through: :user_shifts

  def full_name
    "#{first_name} #{last_name}"
  end
end

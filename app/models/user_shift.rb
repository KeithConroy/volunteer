class UserShift < ApplicationRecord
  belongs_to :shift
  belongs_to :user

  validates :shift, uniqueness: { scope: [:user] }
end

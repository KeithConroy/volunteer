class UserShift < ApplicationRecord
  belongs_to :shift
  belongs_to :user

  validates :shift, uniqueness: { scope: [:user] }

  after_create :update_shift

  private

  def update_shift
    shift.remaining_spots -= 1
    shift.save
  end
end

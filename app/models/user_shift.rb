class UserShift < ApplicationRecord
  belongs_to :shift
  belongs_to :user

  validates :shift, uniqueness: { scope: [:user] }

  after_create :decrease_remaining_spots
  after_destroy :increase_remaining_spots

  private

  def decrease_remaining_spots
    shift.remaining_spots -= 1
    shift.save
  end


  def increase_remaining_spots
    shift.remaining_spots += 1
    shift.save
  end
end

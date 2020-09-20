class Organization < ApplicationRecord
  has_many :shift_types
  has_many :addresses
  has_many :roles

  def shifts
    Shift.where(shift_type: [shift_types.pluck(:id)])
  end
end

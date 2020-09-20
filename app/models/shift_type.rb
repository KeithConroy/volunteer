class ShiftType < ApplicationRecord
  belongs_to :organization
  belongs_to :role
  belongs_to :address
end

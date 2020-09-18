class ActivityInstance < ApplicationRecord
  belongs_to :activity_type
  belongs_to :address
  has_many :activity_slots

  def remaining_slots
    slots - activity_slots.count
  end
end

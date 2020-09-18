class ActivitySlot < ApplicationRecord
  belongs_to :activity_instance
  belongs_to :user
end

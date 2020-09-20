class ShiftType < ApplicationRecord
  acts_as_paranoid

  belongs_to :organization
  belongs_to :role, optional: true
  belongs_to :address

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

end

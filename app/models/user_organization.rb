class UserOrganization < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  STATUSES = [:pending, :approved, :banned]

  enum status: STATUSES

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

end

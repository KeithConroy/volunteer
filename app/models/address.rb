class Address < ApplicationRecord
  belongs_to :organization

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

end

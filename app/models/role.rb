class Role < ApplicationRecord
  acts_as_paranoid

  belongs_to :organization

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

end

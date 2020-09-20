class UserOrganization < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  scope :pending, -> { where(is_approved: [nil, false]) }
  scope :approved, -> { where(is_approved: true) }

end

class UserOrganization < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  STATUSES = [:pending, :approved, :banned]

  enum status: STATUSES

end

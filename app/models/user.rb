class User < ApplicationRecord
  has_many :user_shifts
  has_many :shifts, through: :user_shifts

  has_many :user_roles
  has_many :roles, through: :user_roles

  has_many :user_organizations
  has_many :organizations, through: :user_organizations

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin_organization
    # AdminUser.where(user_id: id).first&.organization
    Organization.first
  end

  def has_role?(role_id)
    user_roles.where(role_id: role_id).present?
  end

  def has_access?(organization_id)
    user_organizations.approved.where(organization_id: organization_id).present?
  end

end

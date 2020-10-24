class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  has_many :user_shifts
  has_many :shifts, through: :user_shifts

  has_many :user_roles
  has_many :roles, through: :user_roles

  has_many :user_organizations
  has_many :organizations, through: :user_organizations

  has_many :organization_admins
  has_many :admin_organizations, through: :organization_admins, source: :organization, class_name: 'Organization'

  scope :for_current_organization, -> { joins(:user_organizations).where(user_organizations: {organization_id: Thread.current[:organization_id]}) }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(
        email: data['email'],
        first_name: data['first_name'],
        last_name: data['last_name'],
        avatar_url: data['avatar_url'],
        email: data['email'],
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  def full_name
    if first_name
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def admin_organization
    admin_organizations.first
  end

  def has_role?(role_id)
    user_roles.where(role_id: role_id).present?
  end

  def has_access?(organization_id)
    user_organizations.approved.where(organization_id: organization_id).present?
  end

  def hours
    shifts.completed.map(&:hours).sum
  end

  def hours_by_shift_type
    shifts.completed.group_by(&:shift_type_id).map{|k,v| [ShiftType.find(k).name ,v.map(&:hours).sum]}.to_h
  end

  def hours_by_organization
    shifts.completed.group_by(&:organization).map{|k,v| [k.name ,v.map(&:hours).sum]}.to_h
  end

  def current_user_org
    user_organizations.for_current_organization.first
  end
end

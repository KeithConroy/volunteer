class Organization < ApplicationRecord
  has_many :shift_types
  has_many :addresses
  has_many :roles
end

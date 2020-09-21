class Organization < ApplicationRecord
  has_many :shift_types
  has_many :addresses
  has_many :roles

  has_many :user_organizations
  has_many :users, through: :user_organizations

  def shifts
    shift_types.flat_map(&:shifts)
  end

  def top_volunteers
    Shift.where(shift_type: [shift_types.pluck(:id)])
      .joins(:user_shifts)
      .group_by(&:users)
      .map{|k,v| [k.first, v.count]}
      .sort_by {|a| a[1]}
      .first(10)
      .to_h
    end

end

class ShiftType < ApplicationRecord
  acts_as_paranoid

  belongs_to :organization
  belongs_to :role, optional: true
  belongs_to :address

  has_many :shifts

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

  def fill_percentage
    counts = shifts.completed.pluck(:remaining_spots, :spots)
    remaining, total = counts.transpose.map(&:sum)
    rate = (total - remaining) / total.to_f
    "#{rate * 100}%"
  end

  def top_volunteers
    shifts.joins(:user_shifts)
      .group_by(&:users)
      .map{|k,v| [k.first, v.count]}
      .sort_by {|a| a[1]}
      .first(10)
      .to_h
  end
end

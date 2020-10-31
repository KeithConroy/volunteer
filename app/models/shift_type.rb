class ShiftType < ApplicationRecord
  acts_as_paranoid

  belongs_to :organization
  belongs_to :role, optional: true
  belongs_to :address

  has_many :shifts

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

  def fill_percentage
    if shifts.completed.any?
      counts = shifts.completed.pluck(:remaining_spots, :spots)
      remaining, total = counts.transpose.map(&:sum)
      rate = (total - remaining) / total.to_f
      "#{(rate * 100).round(2)}%"
    else
      'N/A'
    end
  end

  def top_volunteers
    UserShift.where(shift_id: shifts.pluck(:id))
      .group_by(&:user)
      .map{|k,v| [k, v.count]}
      .sort_by {|a| a[1]}
      .first(10)
      .to_h
  end
end

class Shift < ApplicationRecord
  belongs_to :shift_type
  has_many :user_shifts
  has_many :users, through: :user_shifts

  delegate :name, :organization, :role, :description, to: :shift_type

  scope :scheduled, -> { where("starts_at > ?", DateTime.now) }
  scope :completed, -> { where("starts_at < ?", DateTime.now) }
  scope :for_current_organization, -> { joins(:shift_type).where(shift_types: {organization_id: Thread.current[:organization_id]}) }

  before_create :set_remaining_spots

  def formatted_date
    starts_at.strftime("%a %b %d, %Y")
  end

  def formatted_time_range
    "#{starts_at.strftime("%-I:%M %p")} - #{ends_at.strftime("%-I:%M %p")}"
  end

  def formatted_available_spots
    "#{remaining_spots || spots}/#{spots}"
  end

  def formatted_filled_spots
    "#{user_shifts.count}/#{spots}"
  end

  def hours
    ((ends_at - starts_at) / 1.hour).round
  end

  private

  def set_remaining_spots
    self.remaining_spots = self.spots
  end
end

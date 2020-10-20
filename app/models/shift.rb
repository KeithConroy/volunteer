class Shift < ApplicationRecord
  belongs_to :organization
  belongs_to :shift_type
  belongs_to :schedule, optional: true
  has_many :user_shifts
  has_many :users, through: :user_shifts

  delegate :name, :role, :description, to: :shift_type

  scope :scheduled, -> { where("date >= ?", Date.today) }
  scope :completed, -> { where("date < ?", Date.today) }
  scope :available, -> { where.not(remaining_spots: 0) }
  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

  before_create :set_remaining_spots

  def formatted_date
    date.strftime("%a %b %d, %Y")
  end

  def formatted_time_range
    "#{start_time.strftime("%-I:%M %p")} - #{end_time.strftime("%-I:%M %p")}"
  end

  def formatted_available_spots
    "#{remaining_spots || spots}/#{spots}"
  end

  def formatted_filled_spots
    "#{user_shifts.count}/#{spots}"
  end

  def hours
    ((end_time - start_time) / 1.hour).round
  end

  private

  def set_remaining_spots
    self.remaining_spots = self.spots
  end
end

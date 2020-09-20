class Shift < ApplicationRecord
  belongs_to :shift_type
  has_many :user_shifts
  has_many :users, through: :user_shifts

  delegate :name, :organization, :role, :description, to: :shift_type

  scope :scheduled, -> { where("starts_at > ?", DateTime.now) }
  scope :completed, -> { where("starts_at < ?", DateTime.now) }

  def remaining_slots
    slots - user_shifts.count
  end

  def formatted_date
    starts_at.strftime("%a %b %d, %Y")
  end

  def formatted_time_range
    "#{starts_at.strftime("%-I:%M %p")} - #{ends_at.strftime("%-I:%M %p")}"
  end

  def formatted_available_slots
    "#{remaining_slots}/#{slots}"
  end

  def formatted_filled_slots
    "#{user_shifts.count}/#{slots}"
  end
end

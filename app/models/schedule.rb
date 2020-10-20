class Schedule < ApplicationRecord
  belongs_to :organization
  belongs_to :shift_type
  has_many :shifts

  delegate :name, :role, :description, to: :shift_type

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

  after_create :create_shifts

  FREQUENCIES = [:daily, :weekly]

  enum frequency: FREQUENCIES

  def formatted_dates
    "#{start_date.strftime("%a %b %d, %Y")} - #{end_date.strftime("%a %b %d, %Y")}"
  end

  def formatted_time_range
    "#{start_time.strftime("%-I:%M %p")} - #{end_time.strftime("%-I:%M %p")}"
  end

  def formatted_frequency
    string = case frequency.to_sym
    when :daily
      'Daily'
    when :weekly
      "Every #{}"
    end

    # if end_date.present?
    #   string += " until #{end_date.strftime("%a %b %d, %Y")}"
    # end

    string
  end

  def create_shift(date)
    shifts.create!(
      organization_id: organization_id,
      shift_type_id: shift_type_id,
      spots: spots,
      date: date,
      start_time: start_time,
      end_time: end_time,
    )
  end

  private

  def create_shifts
    puts 'creating shifts'

    stop_date = [Date.today + days_out.days, end_date].min

    case frequency.to_sym
    when :daily
      d = start_date
      while true
        create_shift(d)
        return if d == stop_date
        d += 1.day
      end
    when :weekly
    end
  end

  def make_datetime(d,t)
    DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)
  end

end

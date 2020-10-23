class Address < ApplicationRecord
  belongs_to :organization

  scope :for_current_organization, -> { where(organization_id: Thread.current[:organization_id]) }

  def formatted
    if line_2.present?
      "#{line_1}, #{line_2}, #{city} #{state} #{zip_code}"
    else
      "#{line_1}, #{city} #{state} #{zip_code}"
    end
  end
end

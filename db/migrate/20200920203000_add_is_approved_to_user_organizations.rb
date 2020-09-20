class AddIsApprovedToUserOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :user_organizations, :is_approved, :boolean
  end
end

class AddStatusToUserOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :user_organizations, :status, :integer
  end
end

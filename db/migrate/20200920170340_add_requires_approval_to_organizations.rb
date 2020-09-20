class AddRequiresApprovalToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :requires_approval, :boolean
  end
end

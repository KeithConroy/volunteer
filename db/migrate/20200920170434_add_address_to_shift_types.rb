class AddAddressToShiftTypes < ActiveRecord::Migration[6.0]
  def change
    add_reference :shift_types, :address, index: true
  end
end

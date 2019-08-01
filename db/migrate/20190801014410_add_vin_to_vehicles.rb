class AddVinToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :vin, :string, null: false
  end
end

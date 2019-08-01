class MoreColsForAsyncProcessingToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :fleetio_vehicle_id, :integer
    add_column :vehicles, :total_gallons, :decimal
    add_column :vehicles, :total_miles, :decimal
  end
end

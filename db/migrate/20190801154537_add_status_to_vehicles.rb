class AddStatusToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :status_id, :integer, default: 1
  end
end

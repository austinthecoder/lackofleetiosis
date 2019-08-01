class AddMoreColsToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :make, :string
    add_column :vehicles, :model, :string
    add_column :vehicles, :year, :integer
    add_column :vehicles, :trim, :string
    add_column :vehicles, :color, :string
    add_column :vehicles, :image_url, :text
  end
end

class EnsureVinIsUniq < ActiveRecord::Migration[5.2]
  def change
    add_index :vehicles, [:vin], unique: true
  end
end

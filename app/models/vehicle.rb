class Vehicle < ApplicationRecord
  validates :vin, uniqueness: {scope: :vin}
end

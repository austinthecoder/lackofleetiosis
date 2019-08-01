class Vehicle < ApplicationRecord
  validates :vin, uniqueness: {scope: :vin}

  def as_json(*)
    {
      id: id,
      vin: vin,
      make: make,
      model: model,
      year: year,
      trim: trim,
      color: color,
      image_url: image_url,
    }
  end
end

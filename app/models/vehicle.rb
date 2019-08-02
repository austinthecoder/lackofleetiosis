class Vehicle < ApplicationRecord
  validates :vin, uniqueness: {scope: :vin}

  def status
    case status_id
    when 1
      :unprocessed
    when 2
      :processed
    when 3
      :error
    end
  end

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
      status: status,
      total_gallons: total_gallons,
      total_miles: total_miles,
    }
  end
end

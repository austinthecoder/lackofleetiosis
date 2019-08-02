class Vehicle < ApplicationRecord
  STATUSES = {1 => :unprocessed, 2 => :processed, 3 => :error}

  validates :vin, uniqueness: {scope: :vin}

  def status
    STATUSES[status_id]
  end

  def status=(value)
    self.status_id = STATUSES.key(value)
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

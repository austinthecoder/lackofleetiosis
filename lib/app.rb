class App
  def self.start
    new(fleetio: Fleetio.start)
  end

  def initialize(fleetio:)
    @fleetio = fleetio
  end

  def add_vehicle(vin:)
    vin = vin.to_s.strip

    if vin.blank?
      return Ivo.(status: :unprocessable_entity, errors: ['VIN is required.'])
    end

    result = fleetio.fetch_vehicle(vin: vin)

    case result.status
    when :ok
      vehicle = Vehicle.new(
        vin: vin,
        fleetio_vehicle_id: result.vehicle[:id],
        make: result.vehicle[:make],
        model: result.vehicle[:model],
        year: result.vehicle[:year],
        trim: result.vehicle[:trim],
        color: result.vehicle[:color],
        image_url: result.vehicle[:default_image_url_large],
      )

      if vehicle.save
        VehicleProcessorJob.perform_later(vehicle.id)

        Ivo.(status: :created, id: vehicle.id)
      else
        Ivo.(status: :unprocessable_entity, errors: vehicle.errors.values.flatten)
      end
    when :not_found
      Ivo.(status: :unprocessable_entity, errors: ['Unable to identify a vehicle.'])
    else
      Ivo.(status: :service_unavailable, errors: ['Service is unavailable at the moment.'])
    end
  end

  def fetch_vehicles
    Vehicle.all
  end

  def fetch_vehicle(id:)
    Vehicle.find_by(id: id)
  end

  def process_vehicle(id:)
    vehicle = fetch_vehicle(id: id)

    result = fleetio.fetch_fuel_entries(vehicle_id: vehicle.fleetio_vehicle_id)

    total_gallons = result.fuel_entries.sum { |fe| fe[:us_gallons].to_d }
    total_miles = result.fuel_entries.sum { |fe| fe[:usage_in_mi].to_d }

    Vehicle.where(id: id).update_all(status_id: 2, total_gallons: total_gallons, total_miles: total_miles)
  end

  private

  attr_reader :fleetio
end

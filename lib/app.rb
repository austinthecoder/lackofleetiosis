class App
  def self.start
    new(fleetio: Fleetio.start)
  end

  def initialize(fleetio:)
    @fleetio = fleetio
  end

  def add_vehicle(vin:)
    vehicle = Vehicle.new(vin: vin.to_s.strip)

    if vehicle.invalid?
      return Ivo.(status: :unprocessable_entity, errors: vehicle.errors.values.flatten)
    end

    result = fleetio.fetch_vehicle(vin: vehicle.vin)

    case result.status
    when :ok
      vehicle.assign_attributes(
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
    return if vehicle.status == :processed

    result = fleetio.fetch_fuel_entries(vehicle_id: vehicle.fleetio_vehicle_id)

    if result.status == :ok
      total_gallons = result.fuel_entries.sum { |fe| fe[:us_gallons].to_d }
      total_miles = result.fuel_entries.sum { |fe| fe[:usage_in_mi].to_d }

      update_vehicle(vehicle: vehicle, status: :processed, total_gallons: total_gallons, total_miles: total_miles)
    else
      update_vehicle(vehicle: vehicle, status: :error)
    end
  rescue
    update_vehicle(vehicle: vehicle, status: :error) if vehicle&.status == :unprocessed
  end

  def update_vehicle(vehicle: nil, id: nil, **updates)
    vehicle ||= fetch_vehicle(id: id)
    vehicle.update!(**updates)
  end

  private

  attr_reader :fleetio
end

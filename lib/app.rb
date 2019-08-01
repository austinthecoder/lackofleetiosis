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
        make: result.vehicle[:make],
        model: result.vehicle[:model],
        year: result.vehicle[:year],
        trim: result.vehicle[:trim],
        color: result.vehicle[:color],
        image_url: result.vehicle[:default_image_url_large],
      )

      if vehicle.save
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
    Ivo.(status: :ok, vehicles: Vehicle.all)
  end

  def fetch_vehicle(id:)
    vehicle = Vehicle.find_by(id: id)

    if vehicle
      Ivo.(status: :ok, vehicle: vehicle)
    else
      Ivo.(status: :not_found)
    end
  end

  private

  attr_reader :fleetio
end

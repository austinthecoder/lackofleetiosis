class App
  def self.start
    fleetio_api = HTTP.headers(
      'Authorization' => "Token #{ENV['FLEETIO_API_KEY']}",
      'Account-Token' => ENV['FLEETIO_ACCOUNT_TOKEN'],
    )

    new(fleetio_api: fleetio_api)
  end

  def initialize(fleetio_api:)
    @fleetio_api = fleetio_api
  end

  def add_vehicle(vin:)
    vin = vin.to_s.strip

    if vin.blank?
      return Ivo.(status: :unprocessable_entity, errors: ['VIN is required.'])
    end

    resp = fleetio_api.get('https://secure.fleetio.com/api/v1/vehicles')

    if resp.code != 200
      return Ivo.(status: :service_unavailable, errors: ['Service is unavailable at the moment.'])
    end

    fleetio_vehicles = JSON.parse(resp.body.to_s, symbolize_names: true)
    fleetio_vehicle = fleetio_vehicles.find { |v| v[:vin] == vin }

    unless fleetio_vehicle
      return Ivo.(status: :unprocessable_entity, errors: ['Unable to identify a vehicle.'])
    end

    vehicle = Vehicle.new(
      vin: vin,
      make: fleetio_vehicle[:make],
      model: fleetio_vehicle[:model],
      year: fleetio_vehicle[:year],
      trim: fleetio_vehicle[:trim],
      color: fleetio_vehicle[:color],
      image_url: fleetio_vehicle[:default_image_url_large],
    )

    if vehicle.save
      Ivo.(status: :created, id: vehicle.id)
    else
      Ivo.(status: :unprocessable_entity, errors: vehicle.errors.values.flatten)
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

  attr_reader :fleetio_api
end

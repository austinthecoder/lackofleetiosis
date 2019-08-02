class Fleetio
  def self.start
    api = HTTP.headers(
      'Authorization' => "Token #{ENV['FLEETIO_API_KEY']}",
      'Account-Token' => ENV['FLEETIO_ACCOUNT_TOKEN'],
    )

    new(api: api)
  end

  def initialize(api:)
    @api = api
  end

  def fetch_vehicle(vin:)
    resp = api.get('https://secure.fleetio.com/api/v1/vehicles')

    return service_unavailable if resp.code != 200

    vehicles = JSON.parse(resp.body.to_s, symbolize_names: true)
    vehicle = vehicles.find { |v| v[:vin] == vin }

    if vehicle
      Ivo.(status: :ok, vehicle: vehicle)
    else
      Ivo.(status: :not_found)
    end
  rescue HTTP::Error
    service_unavailable
  end

  def fetch_fuel_entries(vehicle_id:)
    resp = api.get("https://secure.fleetio.com/api/v1/vehicles/#{vehicle_id}/fuel_entries")

    return service_unavailable if resp.code != 200

    fuel_entries = JSON.parse(resp.body.to_s, symbolize_names: true)

    Ivo.(status: :ok, fuel_entries: fuel_entries)
  rescue HTTP::Error
    service_unavailable
  end

  private

  attr_reader :api

  def service_unavailable
    Ivo.(status: :service_unavailable, errors: ['Service is unavailable at the moment.'])
  end
end

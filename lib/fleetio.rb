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

    if resp.code != 200
      return Ivo.(status: :service_unavailable, errors: ['Service is unavailable at the moment.'])
    end

    vehicles = JSON.parse(resp.body.to_s, symbolize_names: true)
    vehicle = vehicles.find { |v| v[:vin] == vin }

    if vehicle
      Ivo.(status: :ok, vehicle: vehicle)
    else
      Ivo.(status: :not_found)
    end
  end

  private

  attr_reader :api
end

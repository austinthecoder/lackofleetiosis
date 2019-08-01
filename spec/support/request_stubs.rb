module RequestHelpers
  def stub_fleetio_vehicles_request(data: nil, status: nil)
    url = 'https://secure.fleetio.com/api/v1/vehicles'

    args = {status: status || 200}
    args.merge!(body: data.to_json) if data

    stub_fleetio_request(url: url).to_return(args)
  end

  def stub_fleetio_vehicle_fuel_entries_request(vehicle_id:, data: nil, status: nil)
    url = "https://secure.fleetio.com/api/v1/vehicles/#{vehicle_id}/fuel_entries"

    args = {status: status || 200}
    args.merge!(body: data.to_json) if data

    stub_fleetio_request(url: url).to_return(args)
  end

  private

  def stub_fleetio_request(url:, **args)
    stub_request(:get, url).with(headers: {
      'Authorization' => 'Token FLEETIO_API_KEY',
      'Account-Token' => 'FLEETIO_ACCOUNT_TOKEN',
    })
  end
end

RSpec.configure do |config|
  config.include RequestHelpers
end

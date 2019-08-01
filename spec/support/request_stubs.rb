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

  config.before do
    stub_fleetio_vehicles_request(data: [
      {
        id: 22,
        vin: "22222222222222222",
        make: "Ford",
        model: "F150 Regular Cab",
        year: 2012,
        trim: "EXT",
        color: "Red",
        default_image_url_large: "https://example.com/22222222222222222.png",
      },
      {
        id: 33,
        vin: "33333333333333333",
        make: "Acura",
        model: "Vigor",
        year: 1992,
        trim: "GS",
        color: nil,
        default_image_url_large: "https://example.com/33333333333333333.png",
      },
    ])

    stub_fleetio_vehicle_fuel_entries_request(
      vehicle_id: 22,
      data: [
        {
          us_gallons: '10.3',
          usage_in_mi: '200.7',
        },
        {
          us_gallons: '20.2',
          usage_in_mi: '380.1',
        },
      ],
    )

    stub_fleetio_vehicle_fuel_entries_request(
      vehicle_id: 33,
      data: [
        {
          us_gallons: '15.9',
          usage_in_mi: '270.1',
        },
        {
          us_gallons: '1.0',
          usage_in_mi: nil,
        },
      ],
    )
  end
end

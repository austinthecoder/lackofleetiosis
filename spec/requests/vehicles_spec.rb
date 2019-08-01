RSpec.describe 'vehicles' do
  include ActiveJob::TestHelper

  before do
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

  describe 'creating' do
    context 'without a VIN' do
      it 'status is 422' do
        post '/vehicles'
        expect(response.status).to eq(422)

        post '/vehicles', params: {vin: '  '}
        expect(response.status).to eq(422)
      end

      it 'error is given' do
        data = post '/vehicles'
        expect(data[:errors]).to eq(['VIN is required.'])
      end
    end

    context 'when a Fleetio vehicle does not exist for the VIN' do
      before { @data = post '/vehicles', params: {vin: '11111111111111111'} }

      it 'status is 422' do
        expect(response.status).to eq(422)
      end

      it 'error is given' do
        expect(@data[:errors]).to eq(['Unable to identify a vehicle.'])
      end
    end

    context 'when a vehicle was already created with the same VIN' do
      before { 2.times { @data = post '/vehicles', params: {vin: '22222222222222222'} } }

      it 'status is 422' do
        expect(response.status).to eq(422)
      end

      it 'error is given' do
        expect(@data[:errors]).to eq(['Vehicle was already added.'])
      end
    end

    context 'when the Fleetio API service fails' do
      before do
        stub_fleetio_vehicles_request(status: 503)
        @data = post '/vehicles', params: {vin: '22222222222222222'}
      end

      it 'status is 503' do
        expect(response.status).to eq(503)
      end

      it 'error is given' do
        expect(@data[:errors]).to eq(['Service is unavailable at the moment.'])
      end
    end

    context 'when a Fleetio vehicle exists for the VIN' do
      it 'status is 201' do
        post '/vehicles', params: {vin: '22222222222222222'}
        expect(response.status).to eq(201)
      end

      it 'identifier is returned' do
        data = post '/vehicles', params: {vin: '22222222222222222'}
        expect(data.key?(:id)).to eq(true)
      end

      it 'accepts VINs with extra spaces' do
        post '/vehicles', params: {vin: ' 22222222222222222 '}
        expect(response.status).to eq(201)
      end
    end
  end

  describe 'fetching one' do
    before { @id = post('/vehicles', params: {vin: '22222222222222222'})[:id] }

    context 'when a vehicle does not exist for the given ID' do
      it 'status is 404' do
        get '/vehicles/0'
        expect(response.status).to eq(404)
      end
    end

    context 'when a vehicle exists for the given ID' do
      it 'status is 200' do
        get "/vehicles/#{@id}"
        expect(response.status).to eq(200)
      end

      it 'returns the vehicle' do
        vehicle = get "/vehicles/#{@id}"
        expect(vehicle).to eq(
          id: @id,
          vin: '22222222222222222',
          make: "Ford",
          model: "F150 Regular Cab",
          year: 2012,
          trim: "EXT",
          color: "Red",
          image_url: "https://example.com/22222222222222222.png",
          status: 'unprocessed',
          total_gallons: nil,
          total_miles: nil,
        )
      end

      context "after being processed" do
        it 'set various attributes' do
          perform_enqueued_jobs do
            @id = post('/vehicles', params: {vin: '33333333333333333'})[:id]
          end

          vehicle = get "/vehicles/#{@id}"
          expect(vehicle[:status]).to eq('processed')
          expect(vehicle[:total_gallons]).to eq('16.9')
          expect(vehicle[:total_miles]).to eq('270.1')
        end
      end
    end
  end

  describe 'fetching many' do
    before do
      post('/vehicles', params: {vin: '11111111111111111'})
      @id1 = post('/vehicles', params: {vin: '22222222222222222'})[:id]
      @id2 = post('/vehicles', params: {vin: '33333333333333333'})[:id]
      @vehicles = get '/vehicles'
    end

    it 'status is 200' do
      expect(response.status).to eq(200)
    end

    it 'returns all vehicles' do
      expect(@vehicles.size).to eq(2)
      expect(@vehicles.any? { |v| v[:id] == @id1 }).to eq(true)
      expect(@vehicles.any? { |v| v[:id] == @id2 }).to eq(true)
    end

    it 'returns all data for each vehicle' do
      vehicle = @vehicles.find { |v| v[:id] == @id2 }
      expect(vehicle).to eq(
        id: @id2,
        vin: "33333333333333333",
        make: "Acura",
        model: "Vigor",
        year: 1992,
        trim: "GS",
        color: nil,
        image_url: "https://example.com/33333333333333333.png",
        status: 'unprocessed',
        total_gallons: nil,
        total_miles: nil,
      )
    end
  end
end

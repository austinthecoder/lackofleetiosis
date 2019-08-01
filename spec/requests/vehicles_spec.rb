RSpec.describe 'vehicles' do
  before do
    url = 'https://secure.fleetio.com/api/v1/vehicles'

    headers = {
      'Authorization' => 'Token FLEETIO_API_KEY',
      'Account-Token' => 'FLEETIO_ACCOUNT_TOKEN',
    }

    body = <<~JSON
      [
        {
          "vin": "22222222222222222"
        },
        {
          "vin": "33333333333333333"
        }
      ]
    JSON

    stub_request(:get, url).with(headers: headers).to_return(status: 200, body: body)
  end

  describe 'creating' do
    context 'without a VIN' do
      it 'status is 422' do
        post '/vehicles'
        expect(response.status).to eq(422)

        post '/vehicles', params: {vin: '  '}
        expect(response.status).to eq(422)
      end
    end

    context 'when a Fleetio vehicle does not exist for the VIN' do
      it 'status is 422' do
        post '/vehicles', params: {vin: '11111111111111111'}
        expect(response.status).to eq(422)
      end
    end

    context 'when a Fleetio vehicle exists for the VIN' do
      before { @data = post '/vehicles', params: {vin: '22222222222222222'} }

      it 'status is 422' do
        expect(response.status).to eq(201)

        post '/vehicles', params: {vin: ' 22222222222222222 '} # ignore extra spaces
        expect(response.status).to eq(201)
      end

      it 'identifier is returned' do
        expect(@data.key?('id')).to eq(true)
      end
    end
  end

  describe 'fetching one' do
    before { @id = post('/vehicles', params: {vin: '22222222222222222'})['id'] }

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
          'id' => @id,
        )
      end
    end
  end

  describe 'fetching many' do
    before do
      post('/vehicles', params: {vin: '11111111111111111'})
      @id1 = post('/vehicles', params: {vin: '22222222222222222'})['id']
      @id2 = post('/vehicles', params: {vin: '33333333333333333'})['id']
      @vehicles = get '/vehicles'
    end

    it 'status is 200' do
      expect(response.status).to eq(200)
    end

    it 'returns all vehicles' do
      get '/vehicles'
      expect(@vehicles.size).to eq(2)
      expect(@vehicles.any? { |v| v['id'] == @id1 }).to eq(true)
      expect(@vehicles.any? { |v| v['id'] == @id2 }).to eq(true)
    end
  end
end

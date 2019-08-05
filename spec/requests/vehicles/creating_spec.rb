RSpec.describe 'vehicles – creating' do
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
      expect(@data[:errors]).to eq(['Sorry, that vehicle was not found.'])
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

RSpec.describe 'vehicles – fetching' do
  include ActiveJob::TestHelper

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

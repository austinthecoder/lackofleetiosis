RSpec.describe App do
  include ActiveJob::TestHelper

  describe '#process_vehicle' do
    context 'when already processed' do
      before do
        @id = perform_enqueued_jobs do
          $app.add_vehicle(vin: '22222222222222222').id
        end
      end

      it 'is idempotent' do
        expect {
          $app.process_vehicle(id: @id)
        }.to_not change {
          $app.fetch_vehicle(id: @id)
        }
      end

      it 'does not attempt to use Fleetio' do
        @app = App.new(fleetio: nil)

        expect {
          @app.process_vehicle(id: @id)
        }.to_not raise_error # would raise NoMethodError if attempted to call nil fleetio
      end
    end

    context 'when unprocessed' do
      before do
        @id = $app.add_vehicle(vin: '22222222222222222').id
      end

      it 'becomes processed' do
        expect {
          $app.process_vehicle(id: @id)
        }.to change {
          $app.fetch_vehicle(id: @id).status
        }.from(:unprocessed).to(:processed)
      end

      it 'sets a few attrs' do
        from = [nil, nil]
        to = [BigDecimal('30.5'), BigDecimal('580.8')]

        expect {
          $app.process_vehicle(id: @id)
        }.to change {
          vehicle = $app.fetch_vehicle(id: @id)
          [vehicle.total_gallons, vehicle.total_miles]
        }.from(from).to(to)
      end
    end

    context 'when processing previously failed' do
      it 'reprocesses' do
        id = $app.add_vehicle(vin: '22222222222222222').id

        $app.update_vehicle(id: id, status: :error) # I'd prefer to trigger a failure in a better way

        expect {
          $app.process_vehicle(id: id)
        }.to change {
          $app.fetch_vehicle(id: id).status
        }.from(:error).to(:processed)
      end
    end
  end
end

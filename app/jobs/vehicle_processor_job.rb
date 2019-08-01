class VehicleProcessorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    $app.process_vehicle(id: args[0])
  end
end

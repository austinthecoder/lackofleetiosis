class VehiclesController < ApplicationController
  def create
    fleetio_api = HTTP.headers(
      'Authorization' => "Token #{ENV['FLEETIO_API_KEY']}",
      'Account-Token' => ENV['FLEETIO_ACCOUNT_TOKEN'],
    )

    resp = fleetio_api.get('https://secure.fleetio.com/api/v1/vehicles')

    vin = params['vin'].to_s.strip

    if resp.code == 200
      fleetio_vehicles = JSON.parse(resp.body.to_s)
      fleetio_vehicle = fleetio_vehicles.find { |v| v['vin'] == vin }

      if fleetio_vehicle
        vehicle = Vehicle.new(vin: vin)

        if vehicle.save
          render json: {id: vehicle.id}, status: 201
        else
          head 422
        end
      else
        head 422
      end
    else
      head 422
    end
  end

  def index
    data = Vehicle.all.map do |vehicle|
      {
        id: vehicle.id,
      }
    end
    render json: data
  end

  def show
    vehicle = Vehicle.find_by(id: params[:id])
    if vehicle
      render json: {
        id: vehicle.id,
        vin: vehicle.vin,
      }
    else
      not_found
    end
  end
end

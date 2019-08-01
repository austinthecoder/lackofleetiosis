class VehiclesController < ApplicationController
  def create
    vin = params[:vin].to_s.strip

    if vin.blank?
      render json: {errors: ['VIN is required.']}, status: 422
      return
    end

    fleetio_api = HTTP.headers(
      'Authorization' => "Token #{ENV['FLEETIO_API_KEY']}",
      'Account-Token' => ENV['FLEETIO_ACCOUNT_TOKEN'],
    )

    resp = fleetio_api.get('https://secure.fleetio.com/api/v1/vehicles')

    if resp.code != 200
      render json: {errors: ['Service is unavailable at the moment.']}, status: 503
      return
    end

    fleetio_vehicles = JSON.parse(resp.body.to_s, symbolize_names: true)
    fleetio_vehicle = fleetio_vehicles.find { |v| v[:vin] == vin }

    unless fleetio_vehicle
      render json: {errors: ['Unable to identify a vehicle.']}, status: 422
      return
    end

    vehicle = Vehicle.new(
      vin: vin,
      make: fleetio_vehicle[:make],
      model: fleetio_vehicle[:model],
      year: fleetio_vehicle[:year],
      trim: fleetio_vehicle[:trim],
      color: fleetio_vehicle[:color],
      image_url: fleetio_vehicle[:default_image_url_large],
    )

    if vehicle.save
      render json: {id: vehicle.id}, status: 201
    else
      render json: {errors: vehicle.errors.values.flatten}, status: 422
    end
  end

  def index
    data = Vehicle.all.map do |vehicle|
      build_vehicle_resource(vehicle)
    end
    render json: data
  end

  def show
    vehicle = Vehicle.find_by(id: params[:id])
    if vehicle
      render json: build_vehicle_resource(vehicle)
    else
      not_found
    end
  end

  private

  def build_vehicle_resource(vehicle)
    {
      id: vehicle.id,
      vin: vehicle.vin,
      make: vehicle.make,
      model: vehicle.model,
      year: vehicle.year,
      trim: vehicle.trim,
      color: vehicle.color,
      image_url: vehicle.image_url,
    }
  end
end

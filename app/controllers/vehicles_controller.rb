class VehiclesController < ApplicationController
  def create
    result = $app.add_vehicle(vin: params[:vin])

    case result.status
    when :created
      render json: {id: result.id}, status: 201
    when :unprocessable_entity
      render json: {errors: result.errors}, status: 422
    when :service_unavailable
      render json: {errors: result.errors}, status: 503
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

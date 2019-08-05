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
    render json: $app.fetch_vehicles
  end

  def show
    vehicle = $app.fetch_vehicle(id: params[:id])

    if vehicle
      render json: vehicle
    else
      not_found
    end
  end

  def reprocess
    $app.process_vehicle(id: params[:id])
    head 204
  end
end

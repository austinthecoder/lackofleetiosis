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
    result = $app.fetch_vehicles
    render json: result.resources
  end

  def show
    result = $app.fetch_vehicle(id: params[:id])

    case result.status
    when :ok
      render json: result.resource
    when :not_found
      not_found
    end
  end
end

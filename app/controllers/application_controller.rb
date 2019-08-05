class ApplicationController < ActionController::API
  def not_found
    render json: {error: 'Not found'}, status: 404
  end
end

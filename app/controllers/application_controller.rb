class ApplicationController < ActionController::API
  def not_found
    render json: {message: 'Not found'}, status: 404
  end
end

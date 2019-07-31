class ApplicationController < ActionController::API
  def root
    render json: {message: 'Hello, friends'}
  end

  def not_found
    render json: {error: 'Not found'}, status: 404
  end
end

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    return if request.headers['Authorization'].blank?

    token = request.headers['Authorization'].split(' ').last

    begin
      decoded_token = JwtService.decode(token)

      if decoded_token && decoded_token['user_id']
        @current_user = User.find_by(id: decoded_token['user_id'])
      end
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decode error: #{e.message}"
    rescue JWT::ExpiredSignature
      Rails.logger.error "JWT expired"
    end

    render json: { error: 'Non autorisé' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
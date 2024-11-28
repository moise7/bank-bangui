class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    return if request.headers['Authorization'].blank?

    begin
      token = request.headers['Authorization'].split(' ').last
      decoded_token = JwtService.decode(token)

      if decoded_token
        @current_user = User.find_by(id: decoded_token['user_id'])
      end
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decode error: #{e.message}"
      nil
    end

    render json: { error: 'Non autorisé' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
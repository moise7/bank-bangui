class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :authenticate_user!
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
  end

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

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(username: session_params[:username])
    Rails.logger.debug("Login attempt for username: #{session_params[:username]}")

    if user&.valid_password?(session_params[:password])
      jti = SecureRandom.uuid
      token = JwtService.encode({ user_id: user.id, jti: jti })

      # Update only the jti
      if user.update(jti: jti)
        render json: {
          status: :success,
          user: user.as_json(only: [:id, :username, :email]),
          token: token
        }, status: :ok
      else
        Rails.logger.error("Failed to update user JTI: #{user.errors.full_messages}")
        render json: { error: 'Erreur lors de la connexion' }, status: :internal_server_error
      end
    else
      Rails.logger.debug("Authentication failed for username: #{session_params[:username]}")
      render json: {
        error: 'Nom d\'utilisateur ou mot de passe invalide'
      }, status: :unauthorized
    end
  rescue => e
    Rails.logger.error "Login error: #{e.message}\n#{e.backtrace.join("\n")}"
    render json: {
      error: 'Une erreur est survenue lors de la connexion'
    }, status: :internal_server_error
  end

  def destroy
    if current_user
      current_user.update(jti: SecureRandom.uuid)
      render json: { message: 'Déconnexion réussie' }, status: :ok
    else
      render json: { error: 'Non autorisé' }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
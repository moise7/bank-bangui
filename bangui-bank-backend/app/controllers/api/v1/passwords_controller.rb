class Api::V1::PasswordsController < ApplicationController
  # Skip authentication for the 'forgot' and 'reset' actions
  skip_before_action :authenticate_user!, only: [:forgot, :reset]

  def forgot
    user = User.find_by_email(params.dig(:user, :email))

    if user
      # Generate reset token
      raw_token = user.send(:set_reset_password_token)

      # Send password reset email
      UserMailer.password_reset(user).deliver_now

      render json: {
        message: 'Reset password instructions have been sent to your email.'
      }, status: :ok
    else
      render json: { error: 'Email address not found' }, status: :not_found
    end
  rescue => e
    Rails.logger.error "Password reset error: #{e.message}\n#{e.backtrace.join("\n")}"
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def reset
    token = params[:token].to_s

    # Find user by reset token
    user = User.with_reset_password_token(token)

    if user.present?
      if params[:user][:password].present?
        if user.reset_password(params[:user][:password], params[:user][:password_confirmation])
          # Generate new JWT token after password reset
          jwt_token = JwtService.encode({
            user_id: user.id,
            jti: user.jti
          })

          render json: {
            message: 'Password has been reset successfully',
            token: jwt_token
          }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Password cannot be blank' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or expired reset token' }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

class Api::V1::PasswordsController < ApplicationController
  def forgot
    Rails.logger.info "Received params: #{params.inspect}"
    email = params.dig(:user, :email, :user, :email)&.to_s
    user = User.find_by(email: email)

    if user
      begin
        # Generate reset token
        raw_token = user.send(:set_reset_password_token)

        # Send email
        UserMailer.reset_password_instructions(user, raw_token).deliver_now

        render json: {
          message: 'Reset password instructions have been sent to your email.'
        }, status: :ok
      rescue => e
        Rails.logger.error "Password reset error: #{e.message}"
        render json: {
          error: 'Failed to send reset instructions'
        }, status: :internal_server_error
      end
    else
      render json: {
        error: 'Email address not found'
      }, status: :not_found
    end
  end

  def reset
    token = params.dig(:user, :reset_password_token)
    Rails.logger.info "Received token for reset: #{token}"

    user = User.with_reset_password_token(token)

    if user.nil?
      render json: {
        error: 'Invalid or expired reset token'
      }, status: :unprocessable_entity
    elsif user.reset_password(params.dig(:user, :password), params.dig(:user, :password))
      render json: {
        message: 'Password has been reset successfully.'
      }, status: :ok
    else
      render json: {
        error: 'Failed to reset password'
      }, status: :unprocessable_entity
    end
  end
end
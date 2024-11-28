class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    # Add issued at time for additional security
    payload = payload.merge({
      exp: exp.to_i,
      iat: Time.current.to_i
    })

    begin
      token = JWT.encode(payload, SECRET_KEY, 'HS256')
      Rails.logger.debug("JWT token generated for user_id: #{payload[:user_id]}")
      token
    rescue => e
      Rails.logger.error("JWT encoding error: #{e.message}")
      nil
    end
  end

  def self.decode(token)
    return nil if token.blank?

    begin
      decoded = JWT.decode(token, SECRET_KEY, true, {
        algorithm: 'HS256',
        verify_iat: true
      })[0]

      HashWithIndifferentAccess.new(decoded)
    rescue JWT::ExpiredSignature
      Rails.logger.error('JWT Token has expired')
      nil
    rescue JWT::InvalidIatError
      Rails.logger.error('JWT Token has invalid issued at time')
      nil
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT decode error: #{e.message}")
      nil
    rescue => e
      Rails.logger.error("Unexpected JWT error: #{e.message}")
      nil
    end
  end

  def self.valid_token?(token)
    return false if token.blank?

    begin
      decoded = decode(token)
      return false unless decoded

      # Check if user exists and token matches current JTI
      user = User.find_by(id: decoded[:user_id])
      return false unless user

      # Verify JTI matches
      user.jti == decoded[:jti]
    rescue => e
      Rails.logger.error("Token validation error: #{e.message}")
      false
    end
  end

  private

  def self.token_from_header(header)
    return nil unless header.present?

    # Extract token from "Bearer <token>"
    header.split(' ').last
  rescue => e
    Rails.logger.error("Error extracting token from header: #{e.message}")
    nil
  end
end
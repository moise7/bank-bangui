class OrangeMoneyService
  include HTTParty
  base_uri ENV['ORANGE_MONEY_API_URL'] || 'https://test-emoney-services.w-ha.com/api'

  def initialize
    credentials = Rails.application.credentials.orange_money
    @client_id = credentials[:client_id]
    @client_secret = credentials[:client_secret]
  end


  def authenticate
    auth = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
    puts "Generated Auth Header: Basic #{auth}"

    response = self.class.post('/oauth/v2/token',
      body: { grant_type: 'client_credentials' },
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}"
      }
    )

    puts "Request URL: #{self.class.base_uri}/oauth/v2/token"
    puts "Request Headers: #{response.request.options[:headers]}"
    puts "Request Body: #{response.request.options[:body]}"
    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"

    if response.success?
      response.parsed_response['access_token']
    else
      raise "Error authenticating with Orange Money: #{response.body}"
    end
  end


  def create_payment(amount, phone_number, access_token)
    response = self.class.post('/payment',
      headers: {
        'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json'
      },
      body: {
        amount: amount,
        phone_number: phone_number
      }.to_json
    )

    if response.success?
      response.parsed_response
    else
      raise "Error creating payment: #{response.body}"
    end
  end
end

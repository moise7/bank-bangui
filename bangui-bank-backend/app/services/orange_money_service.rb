# app/services/orange_money_service.rb
class OrangeMoneyService
  include HTTParty
  base_uri 'https://api.orange.com'

  def initialize
    @client_id = ENV['ORANGE_MONEY_CLIENT_ID']
    @client_secret = ENV['ORANGE_MONEY_CLIENT_SECRET']
  end

  def authenticate
    response = self.class.post("/oauth/v2/token", body: {
      grant_type: 'client_credentials',
      client_id: @client_id,
      client_secret: @client_secret
    })

    if response.success?
      response.parsed_response['access_token']
    else
      raise "Error authenticating with Orange Money: #{response.body}"
    end
  end

  def create_payment(amount, phone_number, access_token)
    response = self.class.post("/payment", headers: {
      'Authorization' => "Bearer #{access_token}",
      'Content-Type' => 'application/json'
    }, body: {
      amount: amount,
      phone_number: phone_number
    }.to_json)

    if response.success?
      response.parsed_response
    else
      raise "Error creating payment: #{response.body}"
    end
  end
end

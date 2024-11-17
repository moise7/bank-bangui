# app/controllers/api/v1/exchange_rates_controller.rb
class Api::V1::ExchangeRatesController < ApplicationController
  def latest
    base_currency = params[:base_currency] || 'EUR'
    cache_key = "exchange_rates/#{base_currency}"

    rates = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      response = HTTParty.get(
        "https://v6.exchangerate-api.com/v6/#{ENV['EXCHANGE_RATE_API_KEY']}/latest/#{base_currency}"
      )

      if response.success?
        response.parsed_response
      else
        nil
      end
    end

    if rates
      render json: rates
    else
      render json: { error: 'Failed to fetch exchange rates' }, status: :service_unavailable
    end
  end
end
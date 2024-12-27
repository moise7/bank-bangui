class AIController < ApplicationController
  def analyze_spending
    transactions = current_user.transactions.where(transaction_date: params[:start_date]..params[:end_date])
    categories = transactions.group_by(&:category).transform_values { |t| t.sum(&:amount) }

    ai_response = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY']).chat(
      model: "gpt-4",
      messages: [
        { role: "system", content: "You are a financial advisor." },
        { role: "user", content: "Here are my expenses: #{categories}. How can I improve my budget?" }
      ]
    )
    render json: { advice: ai_response.dig("choices", 0, "message", "content") }
  end
end



Basic NnBiTWF6QzFhV0RuZ25VNjA3SlZmdlVsaW1Yc0YzN3I6S0xsaHJJSWlSSlFZWW1OTXB2N2JuVWQ0V1o5SDlycTlIaHNhUzE0THlCbzk=

curl -X GET -H "Authorization: Bearer NnBiTWF6QzFhV0RuZ25VNjA3SlZmdlVsaW1Yc0YzN3I6S0xsaHJJSWlSSlFZWW1OTXB2N2JuVWQ0V1o5SDlycTlIaHNhUzE0THlCbzk="
"https://api.orange.com/3legged/sandbox/fr/v1/userinfo/"


curl -X POST
-H "Authorization: Basic NnBiTWF6QzFhV0RuZ25VNjA3SlZmdlVsaW1Yc0YzN3I6S0xsaHJJSWlSSlFZWW1OTXB2N2JuVWQ0V1o5SDlycTlIaHNhUzE0THlCbzk="
-H "Content-Type: application/x-www-form-urlencoded"
-H "Accept:application/json"
-d "grant_type=client_credentials"
https://api.orange.com/oauth/v3/token
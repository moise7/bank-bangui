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

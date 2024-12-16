class Api::V1::BudgetsController < ApplicationController
  def show_progress
   
    budget = current_user.budgets.find_by(user_id: current_user.id)
    render json: budget.progress
  end
end

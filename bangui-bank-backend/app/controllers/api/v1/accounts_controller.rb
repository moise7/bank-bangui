class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_user!

  def create_savings_account
    account = Account.new(user: current_user, account_type: 'savings') # Create a savings account for the current user
    if account.save
      render json: { account: account.as_json }, status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def current_account
    account = Account.find_by(user_id: current_user.id) # Fetch the account for the current user
    if account
      render json: { account: account }, status: :ok
    else
      render json: { error: 'Account not found' }, status: :not_found
    end
  end
end
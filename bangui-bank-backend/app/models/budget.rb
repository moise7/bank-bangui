class Budget < ApplicationRecord
  belongs_to :user

  def progress
    total_spent = user.transactions.where(transaction_date: start_date..end_date).sum(:amount)
    {
      total_spent: total_spent,
      remaining: amount - total_spent,
      percentage: ((total_spent / amount) * 100).round(2)
    }
  end
end

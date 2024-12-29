class Account < ApplicationRecord
  belongs_to :user
  validates :account_number, uniqueness: true
  validates :account_type, inclusion: { in: ['savings', 'checking'] }

  # Generate a unique account number
  before_create :generate_account_number

  private
  def generate_account_number
    loop do
      timestamp = Time.now.to_i.to_s[-4..-1] # Use the last 4 digits of the timestamp
      random_number = SecureRandom.random_number(10**4).to_s.rjust(4, '0') # 4-digit random number
      self.account_number = "#{timestamp}#{random_number}" # 8-digit account number

      break unless Account.exists?(account_number: self.account_number)
    end
  end


end

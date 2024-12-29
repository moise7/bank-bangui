class User < ApplicationRecord
  # Associations
  has_one  :account
  has_many :payments
  has_many :transactions
  has_many :budgets

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, authentication_keys: [:username],
         jwt_revocation_strategy: JwtDenylist

  # Validations
  validates :first_name, :last_name, :date_of_birth, :town, :country, presence: true
  validates :middle_name, presence: false
  validates :username, presence: true, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :age_must_be_18_or_older

  validates :username,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { minimum: 3, maximum: 25 },
  format: { with: /\A[a-zA-Z0-9]+(?:[_\- ][a-zA-Z0-9]+)*\z/, message: "can only contain letters, numbers, underscores, or hyphens" }

  validate :restricted_words
  # Callbacks
  before_create :set_default_balance
  before_create :generate_jti

  # Override this method to authenticate users using username instead of email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (username = conditions.delete(:username))
      where(conditions).where(["lower(username) = :value", { value: username.downcase }]).first
    end
  end

  class Transaction < ApplicationRecord
    belongs_to :user
    validates :category, :amount, :transaction_date, presence: true
  end

  class Budget < ApplicationRecord
    belongs_to :user
    validates :amount, :start_date, :end_date, presence: true
  end

  # Method to deposit funds
  def deposit(amount)
    raise "Amount must be positive" if amount <= 0
    update!(balance: (balance || 0) + amount)
  end

  # Method to transfer money
  def transfer_money_to(receiver, amount)
    ActiveRecord::Base.payment do
      raise "Insufficient funds" if balance < amount
      self.balance = (balance || 0) - amount
      save!

      receiver.balance = (receiver.balance || 0) + amount
      receiver.save!

      # Create payment record (optional)
      Payment.create!(
        sender_id: self.id,
        receiver_id: receiver.id,
        amount: amount
      )
    end
  end

  # Generate reset token
  def generate_password_reset_token!
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.current
    save!
  end

  # Check if reset token is expired
  def password_reset_expired?
    password_reset_sent_at < 2.hours.ago
  end

  def reset_password_period_valid?
    reset_password_sent_at && reset_password_sent_at.utc >= 6.hours.ago.utc
  end

  # Check if reset token is valid (token must exist and not be expired)
  def reset_password_token_valid?
    password_reset_token.present? && !password_reset_expired?
  end

  private

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end

  def age_must_be_18_or_older
    if date_of_birth.present? && (Date.today.year - date_of_birth.year) < 18
      errors.add(:date_of_birth, 'You must be 18 or older to sign up.')
    end
  end

  def set_default_balance
    self.balance ||= 0.0
  end

  def normalize_username
    self.username = username.strip.downcase.gsub(/\s+/, '_') if username.present?
  end

  # Check for reserved usernames
  def restricted_words
    reserved = %w[admin support root superuser]
    if reserved.include?(username.downcase)
      errors.add(:username, "is reserved. Please choose a different username.")
    end
  end
end

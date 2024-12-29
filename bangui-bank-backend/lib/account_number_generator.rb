# lib/account_number_generator.rb

class AccountNumberGenerator
  BIN = "123456"  # Example BIN from Mastercard, must be provided by Mastercard.

  def self.generate
    unique_account_number = generate_unique_account_part
    check_digit = calculate_check_digit(BIN + unique_account_number)
    "#{BIN}#{unique_account_number}#{check_digit}"
  end

  private

  def self.generate_unique_account_part
    # Generate a random 9-digit number (to ensure uniqueness).
    # In practice, use a more robust system for uniqueness, such as a sequential generator.
    rand.to_s[2..10].rjust(9, '0')
  end

  def self.calculate_check_digit(account_number)
    sum = 0
    reverse_digits(account_number).each_with_index do |digit, index|
      n = digit.to_i
      if index.even?
        n *= 2
        sum += (n > 9 ? n - 9 : n)
      else
        sum += n
      end
    end
    (10 - sum % 10) % 10
  end

  def self.reverse_digits(number)
    number.chars.reverse
  end
end

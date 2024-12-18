class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    ActiveRecord::Base.transaction do
      sender = current_user
      receiver = User.find_by(email: payment_params[:receiver_email])

      # Log receiver email and sender for debugging
      logger.debug "Sender: #{sender.email}, Receiver: #{receiver&.email}"

      validate_payment(sender, receiver)
      amount = payment_params[:amount].to_f

      # Log the amount being transferred
      logger.debug "Amount to transfer: #{amount}"

      # Update balances within transaction
      sender.with_lock do
        sender.update!(balance: sender.balance - amount)
      end

      receiver.with_lock do
        receiver.update!(balance: receiver.balance + amount)
      end

      payment = Payment.create!(
        user_id: sender.id,
        recipient_id: receiver.id,
        amount: amount,
        description: payment_params[:description],
        # status: 'completed'
      )

      # Move email to background job
      PaymentNotificationJob.perform_later(payment.id)

      render json: {
        message: 'Payment successful',
        balance: sender.balance,
        payment: payment
      }, status: :ok
    end
  rescue ValidationError => e
    logger.error "Validation error: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    logger.error "Record invalid: #{e.message}"
    render json: { error: 'Transaction failed: ' + e.message }, status: :unprocessable_entity
  rescue StandardError => e
    logger.error "Unexpected error: #{e.message}, Backtrace: #{e.backtrace}"
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def index
    payments = Payment.where(user_id: current_user.id)

    payments_with_recipient = payments.map do |payment|
      recipient = User.find_by(id: payment.recipient_id)
      {
        id: payment.id,
        amount: payment.amount,
        description: payment.description,
        user_id: payment.user_id,
        created_at: payment.created_at,
        updated_at: payment.updated_at,
        recipient_first_name: recipient&.first_name,
        recipient_last_name: recipient&.last_name
      }
    end

    render json: { payments: payments_with_recipient }
  end

  private

  def payment_params
    params.require(:payment).permit(:receiver_email, :amount, :description)
  end

  def validate_payment(sender, receiver)
    raise ValidationError, 'Receiver not found' if receiver.nil?
    raise ValidationError, 'Cannot transfer to yourself' if sender == receiver
    raise ValidationError, 'Invalid amount' if payment_params[:amount].to_f <= 0
    raise ValidationError, 'Insufficient funds' if sender.balance < payment_params[:amount].to_f
  end
end

class ValidationError < StandardError; end


# class Api::V1::PaymentsController < ApplicationController
#   before_action :authenticate_user!

#   def create
#     ActiveRecord::Base.transaction do
#       sender = current_user
#       receiver = User.find_by(email: payment_params[:receiver_email])

#       # Log receiver email and sender for debugging
#       logger.debug "Sender: #{sender.email}, Receiver: #{receiver&.email}"

#       validate_payment(sender, receiver)
#       amount = payment_params[:amount].to_f

#       # Log the amount being transferred
#       logger.debug "Amount to transfer: #{amount}"

#       # Update balances within transaction
#       sender.with_lock do
#         sender.update!(balance: sender.balance - amount)
#       end

#       receiver.with_lock do
#         receiver.update!(balance: receiver.balance + amount)
#       end

#       # Integrate Orange Money payment here
#       orange_money_service = OrangeMoneyService.new
#       access_token = orange_money_service.authenticate
#       payment_response = orange_money_service.create_payment(amount, receiver.phone_number, access_token)

#       if payment_response['status'] == 'success'
#         payment = Payment.create!(
#           user_id: sender.id,
#           recipient_id: receiver.id,
#           amount: amount,
#           description: payment_params[:description]
#         )

#         # Move email to background job
#         PaymentNotificationJob.perform_later(payment.id)

#         render json: {
#           message: 'Payment successful',
#           balance: sender.balance,
#           payment: payment
#         }, status: :ok
#       else
#         raise StandardError, "Error processing payment via Orange Money: #{payment_response['message']}"
#       end
#     end
#   rescue ValidationError => e
#     logger.error "Validation error: #{e.message}"
#     render json: { error: e.message }, status: :unprocessable_entity
#   rescue ActiveRecord::RecordInvalid => e
#     logger.error "Record invalid: #{e.message}"
#     render json: { error: 'Transaction failed: ' + e.message }, status: :unprocessable_entity
#   rescue StandardError => e
#     logger.error "Unexpected error: #{e.message}, Backtrace: #{e.backtrace}"
#     render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
#   end

#   def index
#     payments = Payment.where(user_id: current_user.id)

#     payments_with_recipient = payments.map do |payment|
#       recipient = User.find_by(id: payment.recipient_id)
#       {
#         id: payment.id,
#         amount: payment.amount,
#         description: payment.description,
#         user_id: payment.user_id,
#         created_at: payment.created_at,
#         updated_at: payment.updated_at,
#         recipient_first_name: recipient&.first_name,
#         recipient_last_name: recipient&.last_name
#       }
#     end

#     render json: { payments: payments_with_recipient }
#   end

#   private

#   def payment_params
#     params.require(:payment).permit(:receiver_email, :amount, :description)
#   end

#   def validate_payment(sender, receiver)
#     raise ValidationError, 'Receiver not found' if receiver.nil?
#     raise ValidationError, 'Cannot transfer to yourself' if sender == receiver
#     raise ValidationError, 'Invalid amount' if payment_params[:amount].to_f <= 0
#     raise ValidationError, 'Insufficient funds' if sender.balance < payment_params[:amount].to_f
#   end
# end

# class ValidationError < StandardError; end

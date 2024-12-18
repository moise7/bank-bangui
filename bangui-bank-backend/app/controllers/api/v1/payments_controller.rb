class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    ActiveRecord::Base.transaction do
      sender = current_user
      receiver = User.find_by(email: payment_params[:receiver_email])

      validate_payment(sender, receiver)
      amount = payment_params[:amount].to_f

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
        description: payment_params[:description]
      )

      PaymentNotificationJob.perform_later(payment.id)

      render json: {
        message: 'Payment successful',
        balance: sender.balance,
        payment: payment
      }, status: :ok
    end
  rescue ValidationError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: 'Transaction failed: ' + e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def index
    sent_payments = Payment.where(user_id: current_user.id)
    received_payments = Payment.where(recipient_id: current_user.id)

    payments = sent_payments.map do |payment|
      recipient = User.find_by(id: payment.recipient_id)
      {
        id: payment.id,
        type: 'sent',
        amount: payment.amount,
        description: payment.description,
        user_id: payment.user_id,
        created_at: payment.created_at,
        updated_at: payment.updated_at,
        recipient_first_name: recipient&.first_name,
        recipient_last_name: recipient&.last_name
      }
    end + received_payments.map do |payment|
      sender = User.find_by(id: payment.user_id)
      {
        id: payment.id,
        type: 'received',
        amount: payment.amount,
        description: payment.description,
        sender_first_name: sender&.first_name,
        sender_last_name: sender&.last_name,
        created_at: payment.created_at,
        updated_at: payment.updated_at
      }
    end

    render json: { payments: payments }
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

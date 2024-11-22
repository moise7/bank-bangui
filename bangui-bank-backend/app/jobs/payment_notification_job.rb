class PaymentNotificationJob < ApplicationJob
  queue_as :default

  def perform(payment_id)
    payment = Payment.find_by(id: payment_id)
    return unless payment

    sender = payment.user
    receiver = User.find_by(id: payment.recipient_id)

    # Send to sender
    SendGridClient.new.send_email(
      from: 'marketingmoise@gmail.com',
      to: sender.email,
      subject: 'Payment Sent Confirmation',
      content: sender_notification_content(payment, receiver)
    )

    # Send to receiver
    SendGridClient.new.send_email(
      from: 'marketingmoise@gmail.com',
      to: receiver.email,
      subject: 'Payment Received Notification',
      content: receiver_notification_content(payment, sender)
    )
  rescue StandardError => e
    Rails.logger.error "Failed to send payment notification: #{e.message}"
    # You might want to retry or alert admin
  end

  private

  def sender_notification_content(payment, receiver)
    <<~CONTENT
      Payment Successful!

      Amount: $#{payment.amount}
      To: #{receiver.email}
      Description: #{payment.description}
      Date: #{payment.created_at.strftime('%B %d, %Y')}

      Your new balance is: $#{payment.user.balance}

      Thank you for using our service!
    CONTENT
  end

  def receiver_notification_content(payment, sender)
    <<~CONTENT
      You've Received a Payment!

      Amount: $#{payment.amount}
      From: #{sender.email}
      Description: #{payment.description}
      Date: #{payment.created_at.strftime('%B %d, %Y')}

      Your new balance is: $#{User.find(payment.recipient_id).balance}

      Thank you for using our service!
    CONTENT
  end
end 
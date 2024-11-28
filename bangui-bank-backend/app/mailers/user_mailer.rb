# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: 'marketingmoise@gmail.com'

  def payment_email(user, amount)
    @user = user
    @amount = amount

    sendgrid_mail(
      to: @user.email,
      subject: 'Payment Confirmation',
      template: 'payment_email'  # Assuming you have a template for this email
    )
  end

  def password_reset(user)
    @user = user
    @reset_url = "#{frontend_url}/reset-password?token=#{user.reset_password_token}"

    sendgrid_mail(
      to: user.email,
      subject: "Password Reset Instructions",
      template: 'password_reset'  # Assuming you have a template for this email
    )
  end

  private

  def frontend_url
    Rails.env.production? ? 'https://bangui-bank.com' : 'http://localhost:8080'
  end

  # Send email via SendGrid
  def sendgrid_mail(to:, subject:, template:)
    from = SendGrid::Email.new(email: 'marketingmoise@gmail.com')
    to = SendGrid::Email.new(email: to)
    content = SendGrid::Content.new(type: 'text/html', value: render_to_string(template: template))

    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    # Check response status
    if response.status_code != 202
      logger.error "SendGrid error: #{response.status_code} - #{response.body}"
    end
  end
end

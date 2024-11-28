class UserMailer < ApplicationMailer
  default from: 'marketingmoise@gmail.com'

  def reset_password_instructions(user, token, opts={})
    @user = user
    @token = token
    @reset_url = "#{frontend_url}/reset-password?reset_password_token=#{token}"

    from = SendGrid::Email.new(email: 'marketingmoise@gmail.com')
    to = SendGrid::Email.new(email: user.email)

    template_path = Rails.root.join('app/views/user_mailer/password_reset.html.erb')
    template = ERB.new(File.read(template_path))
    html_content = template.result(binding)

    content = SendGrid::Content.new(
      type: 'text/html',
      value: html_content
    )

    mail = SendGrid::Mail.new(from, "Reset Password Instructions", to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    if response.status_code != "202"
      Rails.logger.error "SendGrid error: #{response.status_code} - #{response.body}"
      raise "Failed to send email via SendGrid"
    end

    # Return mail object to satisfy Devise's expectations
    mail
  end

  private

  def frontend_url
    Rails.application.config.x.frontend_url
  end
end

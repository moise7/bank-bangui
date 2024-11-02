# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:8080',
            'https://bangui-bank-frontend.fly.dev/',
            'http://142.93.6.64/',
            'http://142.93.6.64:3000'

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: %w[Authorization Uid]
  end
end
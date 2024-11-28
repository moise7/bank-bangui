require_relative 'boot'

require 'rails/all'
require 'dotenv'

Dotenv.load(
  File.expand_path("../.env.#{Rails.env}", __FILE__),
  File.expand_path('../.env', __FILE__)
)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DeviseVue
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # This also configures session_options for use below
    config.session_store :cookie_store, key: '_interslice_session'

    # Required for all session management (regardless of session_store)
    config.middleware.use ActionDispatch::Cookies

    config.middleware.use config.session_store, config.session_options
    # config.middleware.use ActionDispatch::Flash
    # config.assets.enabled = true
    config.autoload_paths << Rails.root.join('lib')

    config.x.frontend_url = ENV.fetch('FRONTEND_URL') do
      Rails.env.production? ? 'https://bangui-bank.fly.dev' : 'http://localhost:8080'
    end

    # Add default URL options for mailers
    config.action_mailer.default_url_options = {
      host: ENV.fetch('FRONTEND_URL') { config.x.frontend_url }
    }

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # config.api_only = true
  end
end
require File.expand_path('../boot', __FILE__)
require File.expand_path('../version', __FILE__)

# Pick the frameworks you want:
require 'active_model/railtie'
# require "active_record/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NciTreatmentArmApi
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', 'treatment_arm', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('lib')]

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end

    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

    config.after_initialize do
      config.logger.extend ActiveSupport::Logger.broadcast(SlackLogger.logger)
    end

    config.environment = Rails.application.config_for(:environment)

    # config.before_configuration do
    #   env_file = Rails.root.join('config', 'environment.yml')
    #   if File.exists?(env_file)
    #     YAML.load_file(env_file)[Rails.env].each do |key, value|
    #       ENV[key.to_s] = value
    #     end
    #   end
    # end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

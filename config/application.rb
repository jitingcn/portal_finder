# frozen_string_literal: true

require_relative "boot"

require "rails"

%w(
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  action_mailbox/engine
  action_text/engine
  rails/test_unit/railtie
  #sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module PortalFinder
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.default_locale = :'zh-CN'
    config.i18n.available_locales = %i[zh-CN]

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    config.active_job.queue_adapter = :delayed_job
    config.eager_load_paths << Rails.root.join("extras")
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CengkeApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib)
    config.eager_load_paths += ["#{config.root}/lib"]

    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins '*'
    #     resource '/api/*',
    #         :headers => :any,
    #         :methods => [:get, :post, :put, :patch, :delete, :options],
    #         :expose  => ['Ts'],
    #         :max_age => 3600,
    #         :credentials => false
    #   end
    #   allow do
    #     origins '*'
    #     resource '/doc/*', :headers => :any, :methods => [:get, :post, :put, :patch, :delete, :options]
    #   end
    # end

    config.active_job.queue_adapter = :sidekiq

    Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }
  end
end

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  testing = false    
  #testing with mailcatcher    
  if testing
      puts "testing"
      #==> smtp://127.0.0.1:1025
      #==> http://127.0.0.1:1080
      #config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
      #causes DNS error
      #config.action_mailer.smtp_settings = { :address => "smtp://127.0.0.1", :port => 1025 }
      config.action_mailer.smtp_settings = { :address => "127.0.0.1", :port => 1025 }
      config.action_mailer.default_url_options = { :host => '127.0.0.1:3000' }      
      #to test from mobile browser
      #config.action_mailer.smtp_settings = { :address => "192.168.1.5", :port => 1025 }
      #config.action_mailer.default_url_options = { :host => '192.168.1.5:3000' }      
  else      
      config.action_mailer.smtp_settings = {
        address: "smtp.gmail.com",
        port: 587,
        domain: Rails.application.secrets.domain_name,
        authentication: "plain",
        enable_starttls_auto: true,
        user_name: Rails.application.secrets.email_provider_username,
        password: Rails.application.secrets.email_provider_password
      }
      #config.action_mailer.default_url_options = { :host => '172.16.1.86:3000' }
      # config.action_mailer.default_url_options = { :host => 'safetynotice.com:3002' }
      config.action_mailer.default_url_options = { host: 'localhost:3000' }
  end

  # ActionMailer Config
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  # Send email in development mode?
  config.action_mailer.perform_deliveries = true


  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true



  config.action_dispatch.default_headers = {
      'X-Frame-Options' => ''
  }


end

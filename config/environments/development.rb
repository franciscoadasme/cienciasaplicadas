CbsmWebsite::Application.configure do
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
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = {
    host: "doctorado.cbsm.cl"
  }
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.smtp_settings = {
    authentication: :plain,
    port: 587,
    address: 'smtp.mailgun.org',
    domain: ENV['MAIL_DOMAIN'],
    user_name: ENV['MAIL_USERNAME'],
    password: ENV['MAIL_PASSWORD']
  }
  config.action_mailer.mailgun_settings = {
    api_key: ENV['MAIL_API_KEY'],
    domain: ENV['MAIL_DOMAIN']
  }
  config.action_mailer.perform_deliveries = true

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      bucket: ENV['S3_BUCKET_NAME'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    s3_host_name: "s3-#{ENV['AWS_REGION']}.amazonaws.com",
    s3_region: ENV['AWS_REGION']
  }

  # Automatically inject JavaScript needed for LiveReload
  config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload)
end

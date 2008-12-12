# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')
require File.join(File.dirname(__FILE__), '../lib/app_resources.rb')
require File.join(File.dirname(__FILE__), '../lib/util.rb')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Add new inflection rules using the following format
  # (all these examples are active by default):
  # Inflector.inflections do |inflect|
  #   inflect.plural /^(ox)$/i, '\1en'
  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
  # end
  # See Rails::Configuration for more options
  config.action_controller.session = {
    :session_key => AppResources[:init][:session_key],
    :secret => Util.secret_key("session_secret")
  }
  
  config.gem "gettext",            :version => "1.93.0",   :lib => "gettext/rails"      
  config.gem "mysql",              :version => "2.7"
  config.gem "rmagick",            :version => "~> 2.5.0", :lib => 'RMagick'           
  config.gem "ar-extensions",      :version => "~> 0.7",   :install_options => "--ignore-dependencies"
  config.gem "capistrano",         :version => "~> 2.5"
  config.gem "fastercsv",          :version => "~> 1.2.3"
  config.gem "json",               :version => "~> 1.1.2"
  config.gem "acts_as_searchable", :version => "~> 0.1.0"
  config.gem "mongrel",            :version => "~> 1.1.5"
  config.gem "mongrel_cluster",    :version => "~> 1.0.5", :lib => "mongrel_cluster/init"
  config.gem "memcache-client",    :version => "~> 1.5.0", :lib => 'memcache'
  
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

require 'string_expanse'



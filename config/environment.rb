# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.6' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

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
  # config.action_controller.session_store = :active_record_store

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
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

require 'gettext/rails'
require 'ar-extensions'
require 'string_expanse'

# 規約に違反した携帯メールアドレスへの対応
if TMail::Version=="0.10.7"
  TMail.instance_eval{remove_const 'Parser'}
  require 'tmail_0_10_7_parser_fix'
else
  # ここに来るようならこの if-else をコメントアウトしてテストが通るか試して、
  # 通るようなら問題なしなので、ここを削除
  # 通らないようなら、http://d.hatena.ne.jp/urekat/20080312/1205316182 をあたりを参考に修正
  raise "TMail::Version != 0.10.7"
end

# Include your application configuration below
require 'magic_multi_connections'
connection_names = ActiveRecord::Base.configurations.keys.select do |name|
  name =~ /^#{ENV['RAILS_ENV']}_slave/
end
@@connection_pool = connection_names.map do |connection_name|
  length = ENV['RAILS_ENV'].length + 1
  class_name = connection_name[length..-1]
  Object.class_eval <<-EOS
    module #{class_name.camelize}
      establish_connection :#{connection_name}
    end
  EOS
  class_name.camelize.constantize
end
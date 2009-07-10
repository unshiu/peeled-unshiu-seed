require File.join(File.dirname(__FILE__), '../../lib/app_resources.rb')

ActionMailer::Base.smtp_settings = {
  :address => AppResources[:init][:action_mailer_setting_address],
  :port => AppResources[:init][:action_mailer_setting_port],
  :domain => AppResources[:init][:action_mailer_setting_domain],
}

ExceptionNotifier.sender_address = %("#{AppResources[:init][:exception_notifier_from_name]}" <#{AppResources[:init][:exception_notifier_from_address]}>)
ExceptionNotifier.email_prefix = "[#{AppResources[:init][:service_name]}] "
ExceptionNotifier.exception_recipients = AppResources[:init][:exception_recipients]
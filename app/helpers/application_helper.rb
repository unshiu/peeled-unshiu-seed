# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Unshiu::ApplicationHelperModule
  
  Unshiu::Plugins::ACTIVE_LIST.each do |plugin|
    eval("include #{plugin.capitalize}Helper") 
  end
  
end
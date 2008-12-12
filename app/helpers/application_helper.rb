# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Unshiu::ApplicationHelperModule
  
  if Unshiu::Plugins.active_base?
    include BaseHelperModule
  end
  
end

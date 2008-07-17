# = セッションIDの付与
#
# based on http://moriq.tdiary.net/20070209.html#p01
# by moriq <moriq@moriq.com>
#
# cookie support detection inspired by takai http://recompile.net/

class ActionController::Base #:nodoc:
  class_inheritable_accessor :transit_sid_mode
  class_inheritable_accessor :transit_sid_options
  def self.transit_sid(options={})
    if options.kind_of? Symbol
      mode = options
      options = {}
    else
      mode = options[:mode] || :mobile
      options.delete :mode
    end
    self.transit_sid_options = options
    include Jpmobile::TransSid
    self.transit_sid_mode = mode
  end
end

module Jpmobile::TransSid #:nodoc:
  def self.included(controller)
    controller.after_filter(:append_session_id_parameter, controller.transit_sid_options)
  end

  protected
  # URLにsession_idを追加する。
  def default_url_options(options)
    return unless request # for test process 
    return unless apply_transit_sid?
    { session_key => session.session_id }
  end

  private
  # session_keyを返す。
  def session_key
    session_key = request.session_options[:session_key] || '_session_id'
  end
  # session_idを埋め込むためのhidden fieldを出力する。
  def sid_hidden_field_tag
    "<input type='hidden' name='#{CGI::escapeHTML session_key}' value='#{CGI::escapeHTML session.session_id}'>"
  end
  # formにsession_idを追加する。
  def append_session_id_parameter
    return unless request # for test process 
    return unless apply_transit_sid?
    response.body.gsub!(%r{(</form>)}i, sid_hidden_field_tag+'\1')
  end
  # transit_sidを適用すべきかを返す。
  def apply_transit_sid?
    return false if transit_sid_mode == :none
    return true if transit_sid_mode == :always
    if transit_sid_mode == :mobile
      if request.mobile?
        #return !request.mobile.supports_cookie?
        return logged_in?
      else
        return false
      end
    end
    return false
  end
end

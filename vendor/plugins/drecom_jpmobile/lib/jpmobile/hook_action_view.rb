#:stopdoc:
# helperを追加
ActionView::Base.class_eval { include Jpmobile::Helpers }
#:startdoc:

# ActionView::Base を拡張して携帯からのアクセスの場合に携帯向けビューを優先表示する。
# Vodafone携帯(request.mobile == Jpmobile::Mobile::Vodafone)の場合、
#   index_mobile_vodafone.rhtml
#   index_mobile_softbank.rhtml
#   index_mobile.rhtml
#   index.rhtml
# の順にテンプレートが検索される。
class ActionView::Base #:nodoc:
  alias render_file_without_mobile render_file #:nodoc:
  alias render_partial_without_jpmobile render_partial #:nodoc:

  def render_partial(partial_path, object_assigns = nil, local_assigns = {}) #:nodoc:
    mobile_path = mobile_template_path(partial_path, true) if partial_path.class === "String"
    return mobile_path.nil? ? render_partial_without_jpmobile(partial_path, object_assigns, local_assigns) :
    render_partial_without_jpmobile(mobile_path, object_assigns, local_assigns)
  end
  
  def render_file(template_path, use_full_path = true, local_assigns = {})
    if controller.is_a?(ActionController::Base) && m = controller.request.mobile
      vals = []
      c = m.class
      while c != Jpmobile::Mobile::AbstractMobile
        vals << "mobile_"+c.to_s.split(/::/).last.downcase
        c = c.superclass
      end
      vals << "mobile"

      vals.each do |v|
        mobile_path = "#{template_path}_#{v}"
        if file_exists?(mobile_path)
          return render_file_without_mobile(mobile_path, use_full_path, local_assigns)
        end
      end
    end
    render_file_without_mobile(template_path, use_full_path, local_assigns)
  end

  def template_exists?(template_path, extension)
    if controller.is_a?(ActionController::Base) && m = controller.request.mobile
      candidates = []
      c = m.class
      while c != Jpmobile::Mobile::AbstractMobile
        candidates << "mobile_"+c.to_s.split(/::/).last.downcase
        c = c.superclass
      end
      candidates << "mobile"
      candidates.each do |v|
        mobile_path = "#{template_path}_#{v}"
        if partial
          # ActionView::PartialTemplate#extract_partial_name_and_path の動作を模倣
          if mobile_path.include?('/')
            path = File.dirname(mobile_path)
            partial_name = File.basename(mobile_path)
          else
            path = self.controller.class.controller_path
            partial_name = mobile_path
          end
          full_path = File.join(path, "_#{partial_name}")
        else
          full_path = mobile_path
        end
        if finder.file_exists?(full_path)
          return true
        end
      end
    end
    return false
  end
  #alias template_exists_without_mobile? template_exists? #:nodoc:
  
  def mobile_template_path(template_path, partial=false)
    if controller.is_a?(ActionController::Base) && m = controller.request.mobile
      candidates = []
      c = m.class
      while c != Jpmobile::Mobile::AbstractMobile
        candidates << "mobile_"+c.to_s.split(/::/).last.downcase
        c = c.superclass
      end
      candidates << "mobile"

      candidates.each do |v|
        mobile_path = "#{template_path}_#{v}"
        if partial
          # ActionView::PartialTemplate#extract_partial_name_and_path の動作を模倣
          if mobile_path.include?('/')
            path = File.dirname(mobile_path)
            partial_name = File.basename(mobile_path)
          else
            path = self.controller.class.controller_path
            partial_name = mobile_path
          end
          full_path = File.join(path, "_#{partial_name}")
        else
          full_path = mobile_path
        end
        if finder.file_exists?(full_path)
          return mobile_path
        end
      end
    end
    return nil
  end
  
  alias_method :link_to_org, :link_to 
  def link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
    if controller.is_a?(ActionController::Base) && m = controller.request.mobile
      if !html_options.nil? && html_options.key?(:style)
        style = html_options[:style]
        html_options.delete :style if html_options.key? :style
        name = "<span style=\"#{style}\">#{name}</span>"
      end
    end
    link_to_org name, options, html_options, *parameters_for_method_reference
  end
end

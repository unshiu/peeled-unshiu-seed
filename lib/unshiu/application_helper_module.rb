module Unshiu::ApplicationHelperModule
  
  # style を yml から取得する
  def style_value(key)
    StyleResources[key]
  end
  
  def charset
    if request.mobile?
      mobile = request.mobile
      # 条件式は Jpmobile::Filter::Sjis.apply_incoming? からのコピペ
      if mobile && !(mobile.instance_of?(Jpmobile::Mobile::Vodafone)||mobile.instance_of?(Jpmobile::Mobile::Softbank))
        'Shift-JIS'
      else
        'UTF-8'
      end
    else
      'UTF-8'
    end
  end
  
  def style_tag_for_mobile
    <<-END
<style type="text/css">
<![CDATA[a:link{color:#F75200}a:focus{color:#FFFFFF}]]><br />
</style>
    END
  end

  # リストを交互に背景色を変えるデフォルトのデザインに装飾する
  # _param1_:: style_options
  #
  # Examples ) 
  # <% list_cell_for do %>
	#	  <%= date_or_time(base_user.updated_at) %>
	# <% end %>
  def list_cell_for(style_options=nil, &block)
    concat("<div style=\"#{style_value('list_' + cycle('even','odd'))} #{style_options}\">", block.binding)
    concat("#{image_tag_for_default 'Spec_02.gif'}", block.binding)
    concat("<br/>", block.binding)
    yield
    concat("#{image_tag_for_default 'Spec_02.gif'}", block.binding)
    concat("<br/>", block.binding)
    concat("</div>", block.binding)
  end
  
  def link_to_list_cell(name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to(name, options , html_options, *parameters_for_method_reference)
  end
  
  def link_basic_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to(name, options , html_options, *parameters_for_method_reference)
  end
  
  # AppResources["base"]["notice_new_tearm"]日以内ならNew絵文字を出す
  # Date型の場合は純粋な日数のみで判断しTime型なら時間まで加味して判断する
  # datetime:: 日付（Time　or Date)
  def notice_new_if_new(datetime)
 	  if datetime.is_a?(Date)
      return '' if datetime < Date.today - AppResources["base"]["notice_new_tearm"]
    elsif datetime.is_a?(Time)
      return '' if datetime < Time.now - AppResources["base"]["notice_new_tearm"] * 24 * 60 * 60
    else
      return ''
    end
    "<span style='color:#FF0000; text-decoration:blink'></span>"
  end
  
  # 当日中に見ると時間を表示して、それ以外は日付を表示する helper
  def date_or_time(datetime)
    return '' unless datetime

    today = Date.today
    if today.year == datetime.year &&
      today.month == datetime.month &&
      today.day == datetime.day
      return datetime.strftime("%H:%M")
    else
      return datetime.strftime("%m/%d")
    end
  end

  def date_to_s(datetime)
    return '' unless datetime
    
    datetime.strftime("%m/%d")
  end

  def datetime_to_s(datetime)
    return '' unless datetime
    
    datetime.strftime("%Y/%m/%d %H:%M")
  end
  
  # 時間を表示せず日付のみ表示する
  def datetime_to_date(datetime)
    return '' unless datetime
    
    datetime.strftime("%Y/%m/%d")
  end
  
  # FIXME to_s が OS 依存なのか細かい原因は不明だが形式が違うことがあったので統一するためのヘルパ
  def datetime_for_hidden(datetime)
    return nil unless datetime
    datetime.strftime("%Y-%m-%d %H:%M:%S")    
  end
  
  # PKG標準画像を取得
  # _param1_:: ファイル名
  # _param2_:: image option
  def image_tag_for_default(filename, options = {})
    image_tag "/images/default/" + filename, options
  end
  
  # 年月のみ表示する
  # 与えられた値がnilだったら長さ0の文字列を返す
  def data_year_month(datetime)
    return '' unless datetime
    datetime.strftime("%Y/%m")    
  end
  
  # 文字列から Time に変換するヘルパ
  # view だと最終的にまた文字列にするので冗長だが表示形式の共通化のために利用
  def str_to_time(str)
    timearray = ParseDate.parsedate(str)
    Time::local(*timearray[0..-3]) # 後ろから3つめの要素まで
  end

  # 改行コードを <br> に置換するヘルパ
  def br(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end
  
  # 改行コードを <br> に置換するヘルパ with html_escape
  def hbr(str)
    str = html_escape(str)
    br(str)
  end
  
  # キャンセルタグを出力するヘルパ
  def cancel_tag(value = nil, options = {})
    value = _("Cancel button") unless value
    submit_tag(value, {:name => 'cancel'}.merge!(options))
  end
  
  # ページネートにまつわる情報をいろいろ表示するヘルパ
  def paginate_header(page_enumerator)
    <<-END
<div style="#{style_value('inner_title')}">
  #{image_tag_for_default 'Spec_02.gif'}<br />
  #{page_enumerator.page}/#{page_enumerator.last_page}ページ
    全#{page_enumerator.size}件<br />
  #{image_tag_for_default 'Spec_02.gif'}
</div>
#{image_tag_for_default 'Spec_04.gif'}<br />
    END
  end
  
  # ページネートにまつわるリンクをいろいろ表示するヘルパ
  def paginate_links(page_enumerator)
    return '' if page_enumerator.last_page == 1 # 1ページしかないのでリンクはなし
    
    link_params = params.dup
    link_params.delete('commit')
    link_params.delete('action')
    link_params.delete('controller')
    link_params.delete('page')
    link_params.delete('_mobilesns_session_id')
    
    # パラメータを SJIS に変換
    # ただし、文字コードが UTF8 な携帯（Vodafone 3G or Softbank）の場合は、変換しない
    mobile = request.mobile
    apply_encode = mobile && !(mobile.instance_of?(Jpmobile::Mobile::Vodafone)||mobile.instance_of?(Jpmobile::Mobile::Softbank))
    if apply_encode
      encoded_params = {}
      link_params.each{|key, value|
        encoded_params[key] = NKF.nkf('-m0 -x -Ws', value) if value && value.is_a?(String)
      }
    else
      encoded_params = link_params
    end
    
    <<-END
      <table width="100%">
        <tr>
          <td align="left"><span style="font-size:small;">
            #{link_to_portal '前のページ', { :page => page_enumerator.previous_page }.merge(encoded_params), {:accesskey => 4} if page_enumerator.previous_page?}
          </span></td>
          <td align="right"><span style="font-size:small;">
            #{link_to_portal '次のページ', { :page => page_enumerator.next_page }.merge(encoded_params), {:accesskey => 6} if page_enumerator.next_page?}
          </span></td>
        </tr>
        <tr>
          <td align="left"><span style="font-size:small;">
            #{link_to_portal '最初のページ', { :page => page_enumerator.first_page }.merge(encoded_params) unless page_enumerator.page == page_enumerator.first_page}
          </span></td>
          <td align="right"><span style="font-size:small;">
            #{link_to_portal '最後のページ', { :page => page_enumerator.last_page }.merge(encoded_params) unless page_enumerator.page == page_enumerator.last_page}
          </span></td>
        </tr>
      </table>
    END
  end
  
  # 英字入力モードに設定する
  # _additional_options_:: 追加の options。デフォルトよりこっちのほうが優先度は高い
  def alphabet_text_field_options(additional_options = {})
    options = {:istyle => 3, :mode => 'alphabet', :style => "-wap-input-format:&quot;*&lt;ja:en&gt;&quot;", :format=>'*a'}
    options.merge!(additional_options)

    if request.mobile.is_a?(Jpmobile::Mobile::Au)
      options.delete(:mode)
      options.delete(:style) # FIXME style があると au は入力モード指定に対応できなくなるようなので消している。。。がちょっと荒い
    end
    options
  end
  
  # 数字入力モードに設定する
  # _additional_options_:: 追加の options。デフォルトよりこっちのほうが優先度は高い
  def numeric_text_field_options(additional_options = {})
    options = {:istyle => 4, :mode => 'numeric', :style => "-wap-input-format:&quot;*&lt;ja:n&gt;&quot;", :format=>'*N'}
    # NOTICE format = "*N" は au を数字しか入力できないよう制限するらしい
    #        format = "*m" にすると英小文字スタートになるが、全入力モードが使える
    options.merge!(additional_options)
    
    if request.mobile.is_a?(Jpmobile::Mobile::Au)
      options.delete(:mode)
      options.delete(:style) # FIXME style があると au は入力モード指定に対応できなくなるようなので消している。。。がちょっと荒い
    end
    options
  end

  # FIXME error メッセージのデザインを変更しつつ、gettextにも対応しておくためにだいぶ大がかりなことをしている。なんとかしたい
  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    object_names = params.dup
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    if count.zero?
          ''
    else
      if request.mobile?
        # 携帯なら自前のヘルパへ
        error_messages_for_mobile(self, objects, object_names, count, options)
      else
        # それ以外ならデフォルトのヘルパへ
        ActionView::Helpers::ActiveRecordHelper::L10n.error_messages_for(self, objects, object_names, count, options)
      end
    end
  end
  
  # 携帯用エラーメッセージヘルパ
  def error_messages_for_mobile(instance, objects, object_names, count, options)
    # FIXME gettext を使った置換がうまく起こらないのでとりあえずここに日本語で書いてしまう。要修正
    error_message_title = Nn_("%{record}にエラーが発生しました。", "%{record}に%{num}つのエラーが発生しました。")
    error_message_explanation = Nn_("次の項目を確認してください。", "次の項目を確認してください。")
    
    record = ActiveRecord::Base.human_attribute_table_name_for_error(options[:object_name] || object_names[0].to_s)
    
    message_title = ActionView::Helpers::ActiveRecordHelper::L10n.set_error_message_title(error_message_title)
    message_explanation = ActionView::Helpers::ActiveRecordHelper::L10n.set_error_message_explanation(error_message_explanation)
    
    html = {}
    html[:style] = "background-color:#FFE7E7; text-align:left;"

    header_message = n_(message_title, count) % {:num => count, :record => record}
    error_messages = objects.map {|object|
      object.errors.full_messages.map {|msg| '　・' + msg + '<br/>'}
    }
    
    return instance.content_tag(:div,
        image_tag_for_default('Spec_02.gif') <<
        '<br/>' <<
        instance.content_tag(options[:header_tag] || :span, '' + header_message, {:style => "color:#ff0100;"}) <<
        '<br/>' <<
        n_(message_explanation, count) % {:num => count} <<
        '<br/>' <<
        error_messages.to_s <<
        image_tag_for_default('Spec_02.gif'),
      html)
  end
  
  def error_message_on_for_mobile(object, method, prepend_text = "", append_text = "")
    if (obj = instance_variable_get("@#{object}")) && (errors = obj.errors.on(method))
      content = []
      content << "<span style=\"color:#ff0000;\">"
      content <<  "#{prepend_text}#{errors.is_a?(Array) ? errors.first : errors}#{append_text}"
      content << "</span>"
      content.join
    else 
       ''
    end
  end 
  
  # 日付を調整するobserve_fieldを追加する
  # またその後で表示されたタイミングの日付を調整の初期化をするJSを追加する
  # _param1_:: モデル名
  # _param2_:: フィールド名
  def adjusted_datetime(model_name, field_name)
    id_1i = "#{model_name}_#{field_name}_1i"
    id_2i = "#{model_name}_#{field_name}_2i"
    id_3i = "#{model_name}_#{field_name}_3i"
    <<-END
      #{observe_field id_1i, :url => {:controller => :application, :action => 'adjusted_datetime', :model_name => model_name, :field_name => field_name}, 
                             :with => "'year=' + escape(value) + '&month=' + escape($('#{id_2i}').value) + '&day=' + escape($('#{id_3i}').value)"}
      #{observe_field id_2i, :url => {:controller => :application, :action => 'adjusted_datetime', :model_name => model_name, :field_name => field_name},
                             :with => "'year=' + escape($('#{id_1i}').value) + '&month=' + escape(value) + '&day=' + escape($('#{id_3i}').value)"}
	    
	    <script type="text/javascript">
	      Event.observe(window, "load", init_datatime_#{model_name}_#{field_name}, false);
  	  
  	    function init_datatime_#{model_name}_#{field_name}() {
  	      #{remote_function(:url => {:controller => :application, :action => 'adjusted_datetime', :model_name => model_name, :field_name => field_name},
  	                        :with => "'year=' + escape($('#{id_1i}').value) + '&month=' + escape($('#{id_2i}').value) + '&day=' + escape($('#{id_3i}').value)")}
      　　}
      </script>
	  END
	end
	
	# 画像がない場合にエラーにならないようにする
  # _param1_:: source
  # _param2_:: options
	def safety_image_tag(source, options = {})
    image_tag(source, options) unless source.nil?
  end
  
  # hashをソート済み配列に変換する
  # _param1_:: hash
  # return :: ソートされて順番を保持した配列
  def hash2sorted_array(hash)
    hash.to_a.sort { |a,b| a[0] <=> b[0] }
  end
  
  # hashをselect tag用の一覧にして返す
  # _param1_:: hash
  # return :: select tag 用一覧
  def select_type(hash)
    hash.to_a.sort.collect{ |key, val| [val, key] }
  end
  
end
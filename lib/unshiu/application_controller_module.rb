#= Unshiu::ApplicationControllerModule
#
#== Summary
# unshiu アプリケーションとしての規程 module
# 
module Unshiu::ApplicationControllerModule
  
  class << self
    def included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include ExceptionNotifiable
        include AuthenticatedSystem
        
        layout '_application'
        
        protect_from_forgery :secret => Utils.secret_key("session_secret_key")
        
        # 生パスワードをログに出力させない 
        filter_parameter_logging :password
        
        # DoCoMo(FOMA)携帯対応
        # http://jpmobile-rails.org/ticket/22
        session :cookie_only => false
        
        # 携帯向けのセッション保持
        transit_sid
        
        # SJIS化
        # 半角カナ変換あり
        mobile_filter :hankaku => true
        
        # docomoはインラインCSSを使うのにもContent-Typeの指定までしないといけない。不便。
        # TODO jpmobile にいれてしまいたい
        after_filter :set_header
      end
    end
  end

  # selectボックスで日付を選択する際に月の最終日を調整する
  def adjusted_datetime
    @model_name = params[:model_name]
    @field_name = params[:field_name]
    @year =  params[:year]
    @month = params[:month]
    @day =   params[:day]
    @day_count = Time.days_in_month(@month.to_i,@year.to_i)
    render :template => '/common/adjusted_datetime', :layout => false
  end

private

  def set_header
    if request.mobile?
      if request.mobile.is_a?(Jpmobile::Mobile::Docomo)
        headers['Content-Type'] = 'application/xhtml+xml;charset=Shift_JIS'
      end
    end
  end
  
  # 環境がdevelopmentの場合だけtrueをかえす。
  # _return_ developmentのときはtrue, それ以外はfalse
  def development?
    RAILS_ENV == 'development' ? true : false
  end
  
  # キャンセルボタン（:name => 'cancel' なボタン）が押されていれば true
  def cancel?
    params[:cancel] != nil
  end
  
  # ログイン状態ではキャッシュを生成しない
  def cache_erb_fragment(block, name = {}, options = nil)
    if logged_in? then block.call; return end
    
    if @expire_fragment && @expire_fragment.key?(name)
      buffer = eval("_erbout", block.binding)
      pos = buffer.length
      block.call
      write_fragment(name, buffer[pos..-1], options)
      return
    end

    super
  end

  # 有効時間内の fragment cache があれば true
  # 有効時間を過ぎたキャッシュがある場合は消して、false
  # キャッシュがない場合 false
  def has_active_fragment_cache?(name, time = -10.minute, options = nil)
    return false unless perform_caching
    return false if logged_in?
    
    Rails.cache.exist?(name)
    
    fragment_cache_key = fragment_cache_key(name)
    cache_check_file = "#{ActionController::Base.page_cache_directory}#{fragment_cache_key}.cache"
    
    if File.exist?(cache_check_file)
      unless File.mtime(cache_check_file) > time.from_now
        @expire_fragment = {} if @expire_fragment.nil?
        @expire_fragment[name] = options
        return false
      end
      return true
    end
    return false
  end
  
  # 指定時刻以降に生成した fragment cache があれば true
  # 指定時刻より前のキャッシュがある場合は消して、false
  # キャッシュがない場合 false
  # _refresh_time_:: キャッシュを更新したい時刻(Time)
  def has_fresh_fragment_cache?(name, refresh_time, options = nil)
    return false unless perform_caching
    return false if logged_in?
    
    fragment_cache_key = fragment_cache_key(name)
    cache_check_file = "#{cache.cahce_path}#{fragment_cache_key}.cache"
    
    if File.exist?(cache_check_file)
      if File.mtime(cache_check_file) < refresh_time
        @expire_fragment = {} if @expire_fragment.nil?
        @expire_fragment[name] = options
        return false
      end
      return true
    end
    return false
  end
      
  # 多段レイアウトを行うための filter 呼び出し
  # 完了メソッド（名称末尾が done なメソッド）の場合は完了用のレイアウトを使う
  # 完了メソッドの自動割り出しを行っているため、
  # 各 Controller の“末尾”でこのメソッドを呼び出してください
  module ClassMethods
    def nested_layout_with_done_layout
      methods = self.public_instance_methods
      done_methods = methods.reject{|m|
        index = m.index('done')
        index.nil? || index + 'done'.length < m.length
      }
      nested_layout nil, :except => done_methods
      nested_layout ['done'], :only => done_methods
    end
  end
end
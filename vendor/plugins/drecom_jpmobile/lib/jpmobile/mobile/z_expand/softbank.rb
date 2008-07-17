# jpmobile拡張(Softbank) by zizo
module Jpmobile::Mobile
  class Softbank

   #
   def carrier
    :s
   end

   #
   def device_database_name
    'DevicemapSoftbank'
   end

   # user_agentを分割
   def user_agent_split
    @request.user_agent.split(/\/| /)
   end

   # ga
   def ga
    get_ga(0)
   end

   # ブラウザキャッシュサイズ
   def browser_cache
    case ms_type
    when :c3, :c4
     6000
    when :p4, :p5
     12000
    when :p6
     30000
    else
     200000
    end
   end

   # 文字のみのキャッシュ
   def html_cache
    case ms_type
    when :c3, :c4
     6000
    when :p4, :p5
     12000
    when :p6
     12000
    when :w
     30000
    else
     if device_data.html_cache.to_i > 0
      device_data.html_cache
     else
      10000
     end
    end
   end

   # ブラウザタイプ
   def browser_type
    case ms_type
    when :w, :gc3
     :xhtml
    else
     :html
    end
   end

   # ブラウザバージョン
   # モトローダーのみ例外
   def browser_version
    tmp = user_agent_split
    if /^MOT/ =~ tmp[0]
     tmp[4].to_f
    else
     tmp[1].to_f
    end
   end

   # smaf対応状況
   def ma
    case @request.env['HTTP_X_JPHONE_SMAF'].split(/\//)[0]
    when '4'
     1
    when '16'
     2
    when '40'
     3
    when '64'
     5
    when '128'
     7
    end
   end

   # flash対応状況
   def flash_version
    device_data.flash
   end

   # device_type
   def device_type
    @request.env['HTTP_X_JPHONE_MSNAME']
   end

   # device_name
   def device_name
    device_type
   end

   # ms_type判別(端末型名)
   def ms_type
    case user_agent_split[1]
    when '3.0'
     if @request.env['HTTP_X_JPHONE_JAVA']
      :c3
     else
      :c4
     end
    when '4.0', '4.1'
     :p4
    when '4.2'
     if ga == :qqvga
      :p4
     else
      :p5
     end
    when '4.3'
     :p6
    when '5.0'
     :w
    else
     #:3gcというシンボル名が使えないけどどうしよう
     :gc3
    end
   end

   # jpg対応判定
   def is_jpg?
    true
   end

   # ssl対応判定
   def is_ssl?
    true
   end

 end
end

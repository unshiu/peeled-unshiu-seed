# jpmobile拡張(Docomo) by zizo
module Jpmobile::Mobile
  class Docomo

   #
   def carrier
    :i
   end

   #
   def device_database_name
    'DevicemapDocomo'
   end

   # user_agentを分割
   def user_agent_split
    @request.user_agent.split(/\/| |\(|\)|;/)
   end

   # ga
   def ga
    get_ga(10)
   end

   # ブラウザキャッシュサイズ
   def browser_cache
    if user_agent_split.length > 3
     user_agent_split[3].gsub(/c/, '').to_i * 1000
    else
     5000
    end
   end

   # ブラウザタイプ
   def browser_type
    if browser_version >= 2
     :xhtml
    else
     :html
    end
   end

   #
   def html_version
  return device_data.html
    if device_data.html.to_i > 0
     device_data.html
    else
     5.0
    end
   end

   # ブラウザバージョン
   def browser_version
    user_agent_split[1].to_f
   end

   # smaf対応状況
   def ma
    if device_data.sound == "FM"
     2
    else
     0
    end
   end

   # flash対応状況
   def flash_version
    device_data.flash
   end

   # device_type
   def device_type
    user_agent_split[2]
   end

   # device_name
   def device_name
    device_type
   end

   # ms_type判別(端末型名)
   def ms_type
    if browser_version >= 2
     :foma
    else
     :pdc
    end
   end

   # jpg対応判定
   def is_jpg?
    if device_data.jpg === false
     true
    end
   rescue NameError
     true # FIXME 知らない機種は jpeg 対応にしようコード 荒い
   end

   # ssl対応判定
   def is_ssl?
    if device_data.ssl === false
     true
    end
   end

 end
end

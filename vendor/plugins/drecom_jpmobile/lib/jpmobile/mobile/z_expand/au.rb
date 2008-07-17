# jpmobile拡張(Au) by zizo
module Jpmobile::Mobile
 class Au

  #
  def carrier
   :au
  end

  #
  def device_database_name
   'DevicemapAu'
  end

  # user_agentを分割
  def user_agent_split
   @request.user_agent.split(/\/| |-/)
  end

  # ga
  def ga
   get_ga(20)
  end

  # multimedia
  def multimedia
   if @request.env['HTTP_X_UP_DEVCAP_MULTIMEDIA']
    @request.env['HTTP_X_UP_DEVCAP_MULTIMEDIA']
   else
    device_data.up_browser[7, 16]
   end
  end

  # ブラウザキャッシュサイズ
  def browser_cache
   @request.env['HTTP_X_UP_DEVCAP_MAX_PDU']
  end

  # ブラウザタイプ
  def browser_type
   :xhtml
  end

  # ブラウザバージョン
  def browser_version
   user_agent_split[3].to_f
  end

  # smaf対応状況
  def ma
   case multimedia[4, 1]
   when 1
    false
   when '2', '3'
    2
   when '4', '5'
    3
   when '6', '7'
    5
   when '8', '9'
    7
   end
  end

  # flash対応状況
  def flash_version
   multimedia[12, 1]
  end

  # 着flash対応判別
  def is_arrival_flash?
   if device_data.arrival_flash > 0
    return true
   end
  end

  # device_type
  def device_type
   user_agent_split[1]
  end

  # device_name
  def device_name
   if device_data.up_browser.to_s.empty?
    device_type
   else
    device_data.up_browser[0, 5]
   end
  end

  # ms_type判別(端末型名)
  def ms_type
   if is_tuka?
    :tuka
   elsif is_win?
    :win
   else
    :notwin
   end
  end

  # WIN判定(au)
  # 3桁目が3ならWIN（暫定）
  def is_win?
   if device_type[2, 1] == '3'
    true
   end
  end

  # TU-KA判定
  def is_tuka?
   if @request.env['HTTP_X_UP_SUBNO'].to_s[0, 4].to_i >= 800
    true
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

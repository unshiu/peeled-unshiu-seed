# jpmobile拡張(Abstract) by zizo
module Jpmobile::Mobile
 class AbstractMobile

  #
  @@map_dir = File.dirname(__FILE__) + "/map/"

  #
  @device_data = nil

  # キャリア
  def carrier; nil; end

  # 使用DB名
  def device_database_name; nil; end

  # user_agentを分割
  def user_agent_split; nil; end

  # ga
  def ga; nil; end

  # ブラウザキャッシュサイズ
  def browser_cache; 0; end

  # ブラウザタイプ
  def browser_type; :xhtml; end

  # ブラウザバージョン
  def browser_version; 0; end

  # smaf対応状況
  def ma; 0; end

  # flash対応状況
  def flash_version; 0; end

  # device_type
  def device_type; nil; end

  # device_name
  def device_name; nil; end

  # ms_type判別(端末型名)
  def ms_type; nil; end

  # jpg対応判定
  def is_jpg?; false; end

  # ssl対応判定
  def is_ssl?; false; end

  # 着flash対応判別
  def is_arrival_flash?; false; end

  # 画面サイズからga値を返す(スクロールバーのサイズも考慮)
  def get_ga bar_size
   [[:vga, 480], [:qvga, 240]].each {|h|
    if @request.mobile.display.width + bar_size >= h[1] || @request.mobile.display.height >= h[1]
     return h[0]
    end
   }
   return :qqvga
  end

  # DBから端末データ取得。二重selectは避ける
  def device_data
   if @device_data
    @device_data
   else
    @device_data = get_device_data
   end
  end

  # ファイルからデバイスの詳細情報取得
  def get_device_data
    data = eval(device_database_name).new
    begin
      f = File.open(@@map_dir + carrier.to_s + "/" + device_type.to_s, "r")
      Marshal.load(f)
    rescue
      data
    end
  end


 end
end

#
# AnnotateModels
#  http://redmine.unshiu.drecom.jp/issues/show/120
module AnnotateModels
  
  def self.annotate_one_file(file_name, info_block)
    if File.exist?(file_name)
      content = File.read(file_name)

      # Remove old schema info
      content.sub!(/^# #{PREFIX}.*?\n(#.*\n)*\n/, '')
      
      # 改行コードを Unix に合わせるため \r\n を \n に変換 
      content.gsub!(/\r\n/, '\n')

      # バイナリモードで出力
      File.open(file_name, "wb") { |f| f.puts info_block + content }
    end
  end

end

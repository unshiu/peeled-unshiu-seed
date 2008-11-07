desc "Update pot/po files."
task :updatepo do
  require 'locale'
  require 'gettext/utils'
  
  # カスタマイズ部分用のテキストドメイン名(init_gettextで使用する名前)
  additional_name = ''
  
  ENV["MSGMERGE_PATH"] = "msgmerge --sort-output --no-fuzzy-matching"
  
  # 拡張部分のファイル
  unless additional_name.nil? 
    additional_files = []
    additional_files << Dir.glob("{app,config,components,lib}/**/{#{additional_name}*.{rb,rhtml}")
    additional_files.flatten!

    unless additional_files.empty?
      GetText.update_pofiles(additional_name, additional_files,
                             "#{additional_name} 1.0.0"  #カスタマイズ部分のバージョン
                             )
    end
  end
  
end

desc "Create mo-files"
task :makemo do
  require 'gettext/utils'
  GetText.create_mofiles(true, "po", "locale")
end
desc "Update pot/po files."
task :updatepo do
  require 'gettext/utils'
  
  # カスタマイズ部分用のテキストドメイン名(init_gettextで使用する名前)
  additional_name = 'banprest'
  
  # カスタマイズで使う prefix を指定する
  additional_prefixs = []
  
  ENV["MSGMERGE_PATH"] = "msgmerge --sort-output --no-fuzzy-matching"
  # po ファイル作成対象の全ファイル
  all_files = Dir.glob("{app,config,components,lib}/**/*.{rb,rhtml}")

  # 拡張部分のファイル
  unless additional_name.nil? || additional_name.empty?
    additional_files = []
    for additional_prefix in additional_prefixs
      additional_files << Dir.glob("{app,config,components,lib}/**/{#{additional_prefix}*.{rb,rhtml},#{additional_prefix}*/*.{rb,rhtml}}")
    end
    additional_files.flatten!

    unless additional_files.empty?
      GetText.update_pofiles(additional_name, additional_files,
                             "#{additional_name} 0.1.0"  #カスタマイズ部分のバージョン
                             )
    end
  end
  
  # 標準部分のファイル
  standard_files = all_files.reject{|file| additional_files.include?(file)}
  
  GetText.update_pofiles("mobilesns", #テキストドメイン名(init_gettextで使用した名前) 
                         standard_files,
                         # ターゲットとなるファイル
                         "mobilesns 0.5.0"  #アプリケーションのバージョン
                         )
end

desc "Create mo-files"
task :makemo do
  require 'gettext/utils'
  GetText.create_mofiles(true, "po", "locale")
end
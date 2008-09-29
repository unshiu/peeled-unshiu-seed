module Unshiu
  module Plugins
    
    # plugin の有無を確認する
    # ex) Unshiu::Plugins.base?
    def self.method_missing(name, *args)
      name = name.to_s.scan(/\w+\\?/) 
      false if name.empty? || name.size != 1
      File.directory?("#{RAILS_ROOT}/vendor/plugins/#{name[0]}") ? true : false
    end
    
    # unshiu plugin リスト
    LIST = ['base', 'abm', 'dia', 'prf', 'msg', 'pnt', 'cmm', 'mlg', 'mng', 'tpc']
    
    # 現在有効なplugin
    ACTIVE_LIST = LIST.clone.delete_if { |plugin| eval("!#{plugin}?") }
    
  end
end

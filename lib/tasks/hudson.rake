namespace :hudson do
  RAILS_ENV = ENV['RAILS_ENV'] = 'test'
  
  def svn_plugin_trunk(plugin)
    "http://svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{plugin}/trunk/ --username=cruise --password=PCdp5URM"
  end
  
  desc 'all plugin trunk checkout.'
  task :checkout_unshiu_plugin_trunk_all
    Unshiu::Plugins::LIST.each do |plugin|
      if File.exist?("vendor/plugins/#{plugin}/.svn")
        system "svn up vendor/plugins/#{plugin}"
        
      elsif File.exist?("vendor/plugins/#{plugin}")
        system "rm -rf vendor/plugins/#{plugin}"
        system "svn co #{svn_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      
      else
        system "svn co #{svn_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      end
    end
  end
  
  PLUGIN_LIST = ['drecom_jpmobile', 'acts_as_paranoid', 'annotate_models', 'auto_nested_layouts', 'file_column', 'paginating_find', 'acts_as_readonlyable']
  
  desc 'all plugin trunk checkout.'
  task :checkout_plugin_trunk_all
    PLUGIN_LIST.each do |plugin|
      if File.exist?("vendor/plugins/#{plugin}/.svn")
        system "svn up vendor/plugins/#{plugin}"
        
      elsif File.exist?("vendor/plugins/#{plugin}")
        system "rm -rf vendor/plugins/#{plugin}"
        system "svn co #{svn_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      
      else
        system "svn co #{svn_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      end
    end
  end
  
end
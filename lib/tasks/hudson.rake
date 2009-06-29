namespace :hudson do
  require 'unshiu/plugins'
  
  def hudson_svn_unshiu_plugin_trunk(plugin)
    "http://svn.drecom.co.jp/repos/unshiu/#{plugin}/trunk/ --username=cruise --password=PCdp5URM"
  end
  
  def hudson_svn_plugin_trunk(plugin)
    "http://svn.drecom.co.jp/repos/unshiu/plugins/#{plugin}/trunk/ --username=cruise --password=PCdp5URM"
  end
  
  desc 'all unshiu plugin trunk checkout.'
  task :checkout_unshiu_plugin_trunk_all do
    Unshiu::Plugins::LIST.each do |plugin|
      if File.exist?("vendor/plugins/#{plugin}/.svn")
        system "svn up vendor/plugins/#{plugin}"
        
      elsif File.exist?("vendor/plugins/#{plugin}")
        system "rm -rf vendor/plugins/#{plugin}"
        system "svn co #{hudson_svn_unshiu_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      
      else
        system "svn co #{hudson_svn_unshiu_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      end
    end
  end
  
  desc 'all plugin trunk checkout.'
  task :checkout_plugin_trunk_all do
    Unshiu::Plugins::EXTERNAL_LIST.each do |plugin|
      if File.exist?("vendor/plugins/#{plugin}/.svn")
        system "svn up vendor/plugins/#{plugin}"
        
      elsif File.exist?("vendor/plugins/#{plugin}")
        system "rm -rf vendor/plugins/#{plugin}"
        system "svn co #{hudson_svn_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      
      else
        system "svn co #{hudson_svn_plugin_trunk(plugin)} vendor/plugins/#{plugin}"
      end
    end
  end
  
end
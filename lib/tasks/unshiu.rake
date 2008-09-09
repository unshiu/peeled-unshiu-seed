namespace :unshiu do
  
  namespace :plugins do
    require 'unshiu/plugins'
    
    desc 'all plugin trunk install.'
    task :install_trunk_all, "user"
    task :install_trunk_all do |task, args|
      task.set_arg_names ["user"]
      Unshiu::Plugins::LIST.each do |plugin|
        system "rm -rf vendor/plugins/#{plugin}"
        system "ruby script/plugin install svn+ssh://#{args.user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{plugin}/trunk/ "
      end
    end
  
    desc 'plugin trunk install.'
    task :install_trunk, "user", "plugin_name"
    task :install_trunk do |task, args|
      task.set_arg_names ["user", "plugin_name"]
      system "rm -rf vendor/plugins/#{args.plugin_name}"
      system "ruby script/plugin install svn+ssh://#{args.user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{args.plugin_name}/trunk/ "
    end
    
    desc 'all plugin trunk checkout.'
    task :checkout_trunk_all, "user"
    task :checkout_trunk_all do |task, args|
      task.set_arg_names ["user"]
      Unshiu::Plugins::LIST.each do |plugin|
        if File.exist?("vendor/plugins/#{plugin}/.svn")
          system "svn up vendor/plugins/#{plugin}"
          
        elsif File.exist?("vendor/plugins/#{plugin}")
          system "rm -rf vendor/plugins/#{plugin}"
          system "svn co svn+ssh://#{args.user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{plugin}/trunk/ vendor/plugins/#{plugin}"
        
        else
          system "svn co svn+ssh://#{args.user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{plugin}/trunk/ vendor/plugins/#{plugin}"
        end
      end
    end
    
  end

end
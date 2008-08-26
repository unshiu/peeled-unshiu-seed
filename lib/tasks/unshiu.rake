namespace :unshiu do
  
  namespace :plugins do
    plugins = ['base', 'abm', 'dia', 'prf', 'msg', 'pnt', 'cmm', 'mlg', 'mng']
    
    desc 'all plugin trunk install.'
    task :install_trunk_all, "user"
    task :install_trunk_all do |task, args|
      task.set_arg_names ["user"]
      plugins.each do |plugin|
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
    
  end

end
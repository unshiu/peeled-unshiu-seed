namespace :unshiu do
  
  namespace :plugins do
    require 'unshiu/plugins'
    
    def svn_plugin_trunk(user, plugin)
      "svn+ssh://#{user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{plugin}/trunk/"
    end
    
    def svn_plugin_branch(user, plugin, branch_name)
      "svn+ssh://#{user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{plugin}/branches/#{branch_name}/"
    end
    
    desc 'all plugin trunk install.'
    task :install_trunk_all, "user"
    task :install_trunk_all do |task, args|
      task.set_arg_names ["user"]
      Unshiu::Plugins::LIST.each do |plugin|
        system "rm -rf vendor/plugins/#{plugin}"
        system "ruby script/plugin install #{svn_plugin_trunk(args.user,plugin)}"
      end
    end
  
    desc 'plugin trunk install.'
    task :install_trunk, "user", "plugin_name"
    task :install_trunk do |task, args|
      task.set_arg_names ["user", "plugin_name"]
      system "rm -rf vendor/plugins/#{args.plugin_name}"
      system "ruby script/plugin install #{svn_plugin_trunk(args.user,args.plugin_name)}"
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
          system "svn co #{svn_plugin_trunk(args.user,plugin)} vendor/plugins/#{plugin}"
        
        else
          system "svn co #{svn_plugin_trunk(args.user,plugin)} vendor/plugins/#{plugin}"
        end
      end
    end
    
    desc 'all plugin branches checkout.'
    task :checkout_branches_all, "user", "branch_name"
    task :checkout_branches_all do |task, args|
      task.set_arg_names ["user", "branch_name"]
      Unshiu::Plugins::LIST.each do |plugin|
        if File.exist?("vendor/plugins/#{plugin}/.svn")
          system "svn up vendor/plugins/#{plugin}"
          
        elsif File.exist?("vendor/plugins/#{plugin}")
          system "rm -rf vendor/plugins/#{plugin}"
          system "svn co #{svn_plugin_branch(args.user,plugin,args.branch_name)} vendor/plugins/#{plugin}"
        
        else
          system "svn co #{svn_plugin_branch(args.user,plugin,args.branch_name)} vendor/plugins/#{plugin}"
        end
      end
    end
    
    desc 'all plugin generate.'
    task :generate do 
      Unshiu::Plugins::ACTIVE_LIST.each do |plugin|
        system "ruby script/generate #{plugin} #{plugin}"
      end
    end
  end

end
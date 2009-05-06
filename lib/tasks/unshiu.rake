desc "Add schema information (as comments) to model files non schema number"
task :annotate_models do
   require File.join(File.dirname(__FILE__), "../../vendor/plugins/annotate_models/lib/annotate_models.rb")
   require File.join(File.dirname(__FILE__), "../annotate_models_expanse.rb")
   AnnotateModels.do_annotations
end

namespace :unshiu do
  
  namespace :plugins do
    require 'unshiu/plugins'
    
    def svn_plugin(user, plugin)
      "svn+ssh://#{user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/#{plugin}/"
    end
    
    def svn_plugin_trunk(user, plugin)
      svn_plugin(user,plugin) + "trunk/"
    end
    
    def svn_plugin_branch(user, plugin, branch_name)
      svn_plugin(user,plugin) + "branches/#{branch_name}/"
    end
    
    def svn_plugin_tags(user, plugin, version)
      svn_plugin(user,plugin) + "tags/#{plugin}-#{version}/"
    end
    
    def svn_external_plugin(user, plugin)
      "svn+ssh://#{user}@svn.drecom.co.jp/usr/local/svnrepos/unshiu/plugins/#{plugin}/"
    end
    
    def svn_external_plugin_trunk(user, plugin)
      svn_external_plugin +"trunk/"
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
  
    desc 'all plugin tags install.'
    task :install_tags_all, "user", "version"
    task :install_tags_all do |task, args|
      task.set_arg_names ["user", "version"]
      Unshiu::Plugins::LIST.each do |plugin|
        system "rm -rf vendor/plugins/#{plugin}"
        system "ruby script/plugin install #{svn_plugin_tags(args.user,plugin,args.version)}"
        system "mv vendor/plugins/#{plugin}-#{args.version} vendor/plugins/#{plugin}"
      end
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
    
    desc 'all plugin trunk git checkout.'
    task :git_checkout_trunk_all, "user"
    task :git_checkout_trunk_all do |task, args|
      task.set_arg_names ["user"]
      Unshiu::Plugins::LIST.each do |plugin|
        if File.exist?("vendor/plugins/#{plugin}/.git")
          system "git-svn rebase vendor/plugins/#{plugin}"
          
        elsif File.exist?("vendor/plugins/#{plugin}")
          system "rm -rf vendor/plugins/#{plugin}"
          system "git-svn clone #{svn_plugin(args.user,plugin)} -s vendor/plugins/#{plugin}"
        
        else
          system "git-svn clone #{svn_plugin(args.user,plugin)} -s vendor/plugins/#{plugin}"
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
    
    desc 'all plugin tags checkout.'
    task :checkout_tags_all, "user", "version"
    task :checkout_tags_all do |task, args|
      task.set_arg_names ["user", "version"]
      Unshiu::Plugins::LIST.each do |plugin|
        system "rm -rf vendor/plugins/#{plugin}" if File.exist?("vendor/plugins/#{plugin}")
        system "svn checkout #{svn_plugin_tags(args.user,plugin,args.version)} vendor/plugins/#{plugin}"
      end
    end
    
    desc 'all　external plugin trunk install.'
    task :install_external_plugin_trunk_all, "user"
    task :install_external_plugin_trunk_all do |task, args|
      task.set_arg_names ["user"]
      Unshiu::Plugins::EXTERNAL_LIST.each do |plugin|
        system "rm -rf vendor/plugins/#{plugin}" if File.exist?("vendor/plugins/#{plugin}")
        system "svn script/plugin install #{svn_external_plugin_trunk(args.user, plugin)}"
      end
    end
    
    desc 'all　external plugin trunk git checkout.'
    task :git_checkout_external_plugin_trunk_all, "user"
    task :git_checkout_external_plugin_trunk_all do |task, args|
      task.set_arg_names ["user"]
      Unshiu::Plugins::EXTERNAL_LIST.each do |plugin|
        if File.exist?("vendor/plugins/#{plugin}/.git")
          system "git-svn rebase vendor/plugins/#{plugin}"
          
        elsif File.exist?("vendor/plugins/#{plugin}")
          system "rm -rf vendor/plugins/#{plugin}"
          system "git-svn clone #{svn_external_plugin(args.user,plugin)} -s vendor/plugins/#{plugin}"
        
        else
          system "git-svn clone #{svn_external_plugin(args.user,plugin)} -s vendor/plugins/#{plugin}"
        end
      end
    end
    
    desc 'all plugin generate.'
    task :generate do 
      Unshiu::Plugins::LIST.each do |plugin|
        system "yes | ruby script/generate #{plugin} #{plugin}"
      end
    end
    
    desc 'all plugin migrate generate.'
    task :migrate_generate do 
      Unshiu::Plugins::LIST.each do |plugin|
        system "ruby script/generate plugin_migration #{plugin} "
      end
    end
    
    desc 'all plugin template generate.'
    task :template_generate do 
      Unshiu::Plugins::LIST.each do |plugin|
        system "ruby script/generate unshiu_plugin_template_generator #{plugin}"
      end
    end
    
    desc "Report code statistics (KLOCs, etc) from the plugin "
    task :stats, "plugin_name"
    task :stats do |task, args|
      task.set_arg_names ["plugin_name"]
      require 'code_statistics'
      STATS_DIRECTORIES = [
        ["Controllers",        "lib/#{args.plugin_name}/app/controllers"],
        ["Helpers",            "lib/#{args.plugin_name}/app/helpers"], 
        ["Models",             "lib/#{args.plugin_name}/app/models"],
        ["Libraries",          "lib/"],
        ["Integration\ tests", "test/integration"],
        ["Functional\ tests",  "test/functional"],
        ["Unit\ tests",        "test/unit"]
      ].collect { |name, dir| [ name, "#{RAILS_ROOT}/vendor/plugins/#{args.plugin_name}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }
      CodeStatistics.new(*STATS_DIRECTORIES).to_s
    end
    
    desc "Add schema information (as comments) to model files for plugin"
      task :annotate_models, "plugin_name"
      task :annotate_models do |task, args|
        task.set_arg_names ["plugin_name"]

        require File.join(File.dirname(__FILE__), "../../vendor/plugins/annotate_models/lib/annotate_models.rb")
        require File.join(File.dirname(__FILE__), "../annotate_models_expanse.rb")
        AnnotateModels.do_plugin_annotations(args.plugin_name)
    end
    
    desc "gettext2i18n"
    task :gettext2i18n do
      base = Gettext2I18n::Base.new
      Unshiu::Plugins::LIST.each do |plugin|
        base.transform("#{RAILS_ROOT}/vendor/plugins/#{plugin}/lib/")
      end
    end
    
  end
  
  desc "Add schema information (as comments) to model files"
  task :annotate_models do
    require File.join(File.dirname(__FILE__), "../../vendor/plugins/annotate_models/lib/annotate_models.rb")
    require File.join(File.dirname(__FILE__), "../annotate_models_expanse.rb")
    AnnotateModels.do_annotations
  end
 
end
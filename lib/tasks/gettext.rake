desc "Update pot/po files."
task :updatepo, "additional_name", "version"  
task :updatepo do |task, args|
  require 'locale'
  require 'gettext/utils'
  task.set_arg_names ["additional_name", "version"]
  
  ENV["MSGMERGE_PATH"] = "msgmerge --sort-output --no-fuzzy-matching"
  
  unless args.additional_name.nil? 
    additional_files = []
    additional_files << Dir.glob("{app,config,components,lib}/**/#{args.additional_name}*.rb")
    additional_files << Dir.glob("{app,config,components,lib}/**/#{args.additional_name}*/*.html.erb")
    additional_files.flatten!
    
    unless additional_files.empty?
      GetText.update_pofiles(additional_name, additional_files, "#{args.additional_name} #{args.version}")
    end
  end
  
end

desc "Create mo-files"
task :makemo do
  require 'gettext/utils'
  GetText.create_mofiles(true, "po", "locale")
end

plugins = ['base', 'abm', 'dia', 'prf', 'msg', 'pnt', 'cmm', 'mlg', 'mng', 'tpc']

desc 'Continuous build target'
task :cruise do
  RAILS_ENV = ENV['RAILS_ENV'] = 'test'
  
  # install plugin
  plugins.each do |plugin|
    system "rm -rf vendor/plugins/#{plugin}"
    system "svn export http://svn.drecom.co.jp/repos/unshiu/#{plugin}/trunk/  --username=cruise --password=PCdp5URM  vendor/plugins/#{plugin}"
    system "yes | ruby script/generate #{plugin} #{plugin}"
  end
  system "ruby script/generate plugin_migration "
  
  # init data load
  Rake::Task['db:load'].invoke
  
  # rcov output
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  system "find test -name '*_test.rb' -print | xargs /usr/bin/rcov -x /usr/local/lib -o #{out}/coverage/"
end



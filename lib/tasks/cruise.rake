desc 'Continuous build target'
plugins = ['base', 'abm', 'dia', 'prf', 'msg', 'pnt', 'cmm', 'mlg', 'mng', 'tpc']

task :cruise do
  # install plugin
  plugins.each do |plugin|
    system "rm -rf vendor/plugins/#{plugin}"
    system "svn export https://svn.drecom.co.jp/repos/unshiu/#{plugin}/trunk/  --username=cruise --password=PCdp5URM  vendor/plugins/#{plugin}"
    system "yes | ruby script/generate #{plugin} #{plugin}"
  end

  # rcov output
  ENV['RAILS_ENV'] = 'test'
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  system "find test -name '*_test.rb' -print | xargs /usr/bin/rcov -x /usr/local/lib -o #{out}/coverage/"
  # system "/usr/bin/rcov -x /usr/local/lib --rails test/**/*_test.rb -o #{out}/coverage/"
end



desc 'Continuous build target'
task :cruise do
  ENV['RAILS_ENV'] = 'test'
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  # TODO log/ 以下を削除
  system "find test -name '*_test.rb' -print | xargs /usr/bin/rcov -x /usr/local/lib -o #{out}/coverage/"
  # system "/usr/bin/rcov -x /usr/local/lib --rails test/**/*_test.rb -o #{out}/coverage/"
end
#Dir[File.join(File.dirname(__FILE__), 'jpmobile/**/*.rb')].sort.each { |lib| require lib }
Dir[File.join(File.dirname(__FILE__), 'jpmobile/**/*.rb')].sort.each {|lib|
  if(lib.index('dispatcher.rb') == nil)
    require lib
  end
}

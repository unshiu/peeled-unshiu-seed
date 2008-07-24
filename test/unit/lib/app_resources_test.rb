require File.dirname(__FILE__) + '/../../test_helper'

class AppResourcesTest < Test::Unit::TestCase
  
  def setup
    AppResources.instance.load
  end
  
  define_method('test: リソース情報を取得する') do 
    assert_equal AppResources["base"]["mail_domain_name"], "unshiu.drecom.jp"
  end
  
  define_method('test: シンボルででリソース情報を取得する') do 
    assert_equal AppResources[:base][:mail_domain_name], "unshiu.drecom.jp"
  end
    
end
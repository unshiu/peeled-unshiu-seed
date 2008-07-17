require File.dirname(__FILE__)+'/helper'

class AbstractMobileTest < Test::Unit::TestCase
  
  # メールアドレスで対応キャリアを取得する　carrier_by_email　のテスト
  def test_carrier_by_email
    # docomoのアドレス
    carrier = Jpmobile::Email.carrier_by_email("test@docomo.ne.jp")
    assert_equal(Jpmobile::Mobile::Docomo, carrier.class)
    
    # auのアドレス
    carrier = Jpmobile::Email.carrier_by_email("a(--)l@ezweb.ne.jp")
    assert_equal(Jpmobile::Mobile::Au, carrier.class)
    
    # willcomのアドレス
    carrier = Jpmobile::Email.carrier_by_email("dadaea@pdx.ne.jp")
    assert_equal(Jpmobile::Mobile::Willcom, carrier.class)
    
    carrier = Jpmobile::Email.carrier_by_email("xxxe@dj.pdx.ne.jp")
    assert_equal(Jpmobile::Mobile::Willcom, carrier.class)
    
    # softbankのアドレス
    carrier = Jpmobile::Email.carrier_by_email("oeeikx@softbank.ne.jp")
    assert_equal(Jpmobile::Mobile::Softbank, carrier.class)
    
    carrier = Jpmobile::Email.carrier_by_email("iiiaa@r.vodafone.ne.jp")
    assert_equal(Jpmobile::Mobile::Vodafone, carrier.class)
  end
end
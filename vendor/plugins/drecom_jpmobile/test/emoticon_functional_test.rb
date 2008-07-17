require File.dirname(__FILE__)+'/helper'

class EmoticonTestController < ActionController::Base
  mobile_filter
  def docomo_cr
    render :text=>"&#xE63E;"
  end
  def docomo_utf8
    render :text=>[0xe63e].pack("U")
  end
  def docomo_docomopoint
    render :text=>"&#xE6D5;"
  end
  def au_cr
    render :text=>"&#xE488;"
  end
  def au_utf8
    render :text=>[0xe488].pack("U")
  end
  def softbank_cr
    render :text=>"&#xF04A;"
  end
  def softbank_utf8
    render :text=>[0xf04a].pack("U")
  end
  def query
    @q = params[:q]
    render :text=>@q
  end
end

class EmoticonFunctionalTest < Test::Unit::TestCase
  def setup
    init EmoticonTestController
  end
  def test_docomo
    # PC
    get :docomo_cr
    assert_equal "&#xE63E;", @response.body
    get :docomo_utf8
    assert_equal "\xee\x98\xbe", @response.body
    
    # DoCoMo携帯
    user_agent "DoCoMo/2.0 SH902i(c100;TB;W24H12)"
    get :docomo_cr
    assert_equal "\xf8\x9f", @response.body
    get :docomo_utf8
    assert_equal "\xf8\x9f", @response.body
    get :query, :q=>"\xf8\x9f"
    assert_equal "\xee\x98\xbe", assigns["q"]
    assert_equal "\xf8\x9f", @response.body

    get :docomo_docomopoint
    assert_equal "\xf9\x79", @response.body

    # Au携帯電話での閲覧
    user_agent "KDDI-CA32 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0"
    get :docomo_cr
    assert_equal "\xf6\x60", @response.body
    get :docomo_utf8
    assert_equal "\xf6\x60", @response.body
    get :docomo_docomopoint
    assert_equal "［ドコモポイント］".tosjis, @response.body

    # SoftBank携帯電話での閲覧
    user_agent "SoftBank/1.0/910T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1"
    get :docomo_cr
    assert_equal "\e$Gj\x0f", @response.body
    get :docomo_utf8
    assert_equal "\e$Gj\x0f", @response.body
    get :docomo_docomopoint
    assert_equal "［ドコモポイント］", @response.body
 
    # J-PHONE携帯電話での閲覧
    user_agent "J-PHONE/3.0/V301D"
    get :docomo_cr
    assert_equal "\e$Gj\x0f", @response.body
    get :docomo_utf8
    assert_equal "\e$Gj\x0f", @response.body
    get :docomo_docomopoint
    assert_equal "Shift_JIS", @response.charset
    assert_equal "［ドコモポイント］".tosjis, @response.body
  end
  def test_au
    # PC
    get :au_cr
    assert_equal "&#xE488;", @response.body
    get :au_utf8
    assert_equal [0xe488].pack("U"), @response.body

    # Au
    user_agent "KDDI-CA32 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0"
    get :au_cr
    assert_equal "\xf6\x60", @response.body
    get :au_utf8
    assert_equal "\xf6\x60", @response.body
    get :query, :q=>"\xf6\x60"
    assert_equal [0xe488].pack("U"), assigns["q"]
    assert_equal "\xf6\x60", @response.body

    # DoCoMo携帯電話での閲覧
    user_agent "DoCoMo/2.0 SH902i(c100;TB;W24H12)"
    get :au_cr
    assert_equal "\xf8\x9f", @response.body
    get :au_utf8
    assert_equal "\xf8\x9f", @response.body

    # SoftBank携帯電話での閲覧
    user_agent "SoftBank/1.0/910T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1"
    get :au_cr
    assert_equal "\e$Gj\x0f", @response.body
    get :au_utf8
    assert_equal "\e$Gj\x0f", @response.body
  end
  def test_softbank
    # PCから
    get :softbank_cr
    assert_equal "&#xF04A;", @response.body
    get :softbank_utf8
    assert_equal [0xf04a].pack("U"), @response.body

    # SoftBank携帯電話から
    # SoftBank端末から絵文字を送った場合に必ずWebコードで来るのか確認が必要。
    # UTF-8で来るとまずいことが起るので対処が必要。
    # (現状ではフィルタを素通りしてAuの絵文字UTF-8コードと重なってしまうはず)。
    user_agent "SoftBank/1.0/910T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1"
    get :softbank_cr
    assert_equal "\e$Gj\x0f", @response.body
    get :softbank_utf8
    assert_equal "\e$Gj\x0f", @response.body
    get :query, :q=>"\e$Gj\x0f"
    assert_equal [0xf04a].pack("U"), assigns["q"]
    assert_equal "\e$Gj\x0f", @response.body

    # DoCoMo携帯電話での閲覧
    user_agent "DoCoMo/2.0 SH902i(c100;TB;W24H12)"
    get :softbank_cr
    assert_equal "\xf8\x9f", @response.body
    get :softbank_utf8
    assert_equal "\xf8\x9f", @response.body
   
    # Au携帯電話での閲覧
    user_agent "KDDI-CA32 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0"
    get :softbank_cr
    assert_equal "\xf6\x60", @response.body
    get :softbank_utf8
    assert_equal "\xf6\x60", @response.body
  end
end

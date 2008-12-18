#
# 単体テスト用Utilモジュール
# テストクラスにincludeして利用する
#
# ex)  class Hoge < Test::Unit::TestCase
#         include TestUtil::Base::PcControllerTest
#      end
#
module TestUtil
  
  module Base
    
    # PCのコントローラテスト便利モジュール
    module PcControllerTest 
      include AuthenticatedTestHelper
      
      def uploaded_file(path, content_type, filename)
        t = Tempfile.new(filename);
        FileUtils.copy_file(path, t.path)
        (class << t; self; end).class_eval do
          alias local_path path
          define_method(:original_filename) {filename}
          define_method(:content_type) {content_type}
        end
        return t
      end
    end

    class ActionController::TestRequest
      attr_accessor :user_agent
    end
  
    # 携帯のコントローラテスト便利モジュール
    # 3キャリアのUser-Agentでテストをまわす
    module MobileControllerTest 
      include AuthenticatedTestHelper
      
      def setup
        @request    = ActionController::TestRequest.new
        @response   = ActionController::TestResponse.new
        case @count
        when 0:
          @request.user_agent = 'DoCoMo/2.0 SH903i(c100;TB;W24H16) ser012345678912345;'
        when 1:
          @request.user_agent = 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0'
          @request.env["HTTP_X_UP_SUBNO"] = "012345678912345"
        when 2:
          @request.user_agent = 'SoftBank/1.0/910T/TJ001'
          @request.env["HTTP_X_JPHONE_UID"] = "012345678912345"
        end
      end

      def run(result)
        for @count in 0..2
          super
        end
      end
      
      def login(base_user_id = 1)
        @controller.send(:current_base_user=, BaseUser.find(base_user_id))
      end

    end
    
    module UnitTest
      
      # テスト用のfixtureデータを読みemailオブジェクトを返す
      # _param1_:: controller名
      # _param2_:: action名
      def read_mail_fixture(controller, action)
        TMail::Mail.load("#{RAILS_ROOT}/test/fixtures/#{controller}/#{action}.txt")
      end  
    end
    
  end

end

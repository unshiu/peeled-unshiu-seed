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
          @request.user_agent = 'DoCoMo/2.0 SH903i(c100;TB;W24H16)'
        when 1:
          @request.user_agent = 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0'
        when 2:
          @request.user_agent = 'SoftBank/1.0/910T/TJ001'
        end
        
        class << @request.session
          def session_id 
            '_unshiu_test_session_id'
          end
        end
        @token = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA1'), 'unshiu', '_unshiu_test_session_id')
        ActionController::Base.request_forgery_protection_token = :authenticity_token        
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
  end
end

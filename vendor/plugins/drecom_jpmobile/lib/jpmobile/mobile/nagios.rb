# =監視用のnagios
# 携帯ページにアクセスできるようにする

module Jpmobile::Mobile
  # ==監視用のnagios
  class Nagios < AbstractMobile
    # 対応するUser-Agentの正規表現
    USER_AGENT_REGEXP = /^check_http.*\(nagios/

    # 対応するメールアドレスの正規表現
    MAIL_ADDRESS_REGEXP = /@nagios/

    # cookieに対応しているか？
    def supports_cookie?
      true
    end
  end
end


# モバイル検索エンジン Bot で、他のクラスで携帯として識別できないものを拾うクラス

module Jpmobile::Mobile
  class Bot < AbstractMobile
    # 対応するUser-Agentの正規表現
    USER_AGENT_REGEXP = /^Nokia/ # GoogleBot-Mobile

    # cookieに対応しているか？
    def supports_cookie?
      true
    end
  end
end

#== 概要
# 全モデルが　acts_as_readonlyable　対応にになるようにする
class << ActiveRecord::Base
  def inherited_with_read_only(child)
    child.acts_as_readonlyable [:read_only_proxy]
    inherited_without_read_only(child)
  end
  alias_method_chain :inherited, :read_only
end
#
# 全体で利用されるユーティリティ系
#
class Util
  RAND_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz"

  # ランダムな英数字を生成する
  # _param1_:: len 生成する英数字
  # return :: ランダムな英数字
  def self.random_string(len)
    rand_max = RAND_CHARS.size
    ret = ""
    len.times{ ret << RAND_CHARS[rand(rand_max)] }
    ret
  end
  
end
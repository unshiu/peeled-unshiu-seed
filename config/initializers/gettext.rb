# http://zargony.com/2008/02/12/edge-rails-and-gettext-undefined-method-file_exists-*nomethoderror*
# http://rubyforge.org/tracker/index.php?func=detail&aid=17990&group_id=855&atid=3377
#
# ruby-gettext側の問題　ライブラリ側で解決するまで回避策

require 'gettext/rails'

module ActionView
  class Base
    delegate :file_exists?, :to => :finder unless respond_to?(:file_exists?)
  end
end

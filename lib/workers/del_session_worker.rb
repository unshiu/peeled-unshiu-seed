#
# 古い　Session の削除処理をする。
# 
# 
class Session < ActiveRecord::Base; end

class DelSessionWorker < BackgrounDRb::MetaWorker
  set_worker_name :del_session_worker
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  # 指定日時より以前に作成された　Sessionを削除する
  # schedulerにて定時に自動処理するため、直接呼び出すことはない
  def delete
    Session.delete_all(["updated_at < ?",(Time.new - AppResources[:init][:session_active_days].days)])
  end
end


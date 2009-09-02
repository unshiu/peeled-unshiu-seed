require File.dirname(__FILE__) + '/../../../test_helper'
require File.dirname(__FILE__) + '/../../../bdrb_test_helper'
require "#{RAILS_ROOT}/lib/workers/del_session_worker"

class DelSessionWorkerTest < ActiveSupport::TestCase
  fixtures :sessions
  
  define_method('test: delete は古いセッションデータを削除する') do 
    worker = DelSessionWorker.new
    
    Session.record_timestamps = false
    10.times do |i| 
      # 削除対象のデータ
      Session.create({:session_id => i, :updated_at => Time.new - 30.days, :created_at => Time.new - 30.days})
      # 削除対象でないデータ
      Session.create({:session_id => 10 + i, :updated_at => Time.new - 1.days, :created_at => Time.new - 1.days})
    end
    Session.record_timestamps = true

    assert_difference "Session.count", -10 do
      worker.delete
    end
    
    sessions = Session.find(:all)
    sessions.each do | session |
      assert(session.updated_at > Time.new - 7.days) # 7日間残す
    end
    
  end
  
end
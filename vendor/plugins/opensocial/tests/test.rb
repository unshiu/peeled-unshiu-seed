# Copyright (c) 2008 Google Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'test/unit/testsuite'

require File.dirname(__FILE__) + '/person_test'
require File.dirname(__FILE__) + '/group_test'
require File.dirname(__FILE__) + '/activity_test'
require File.dirname(__FILE__) + '/appdata_test'
require File.dirname(__FILE__) + '/rpcrequest_test'
require File.dirname(__FILE__) + '/request_test'
require File.dirname(__FILE__) + '/connection_test'
require File.dirname(__FILE__) + '/online_test'

class TS_AllTests #:nodoc:
  def self.suite
    suite = Test::Unit::TestSuite.new name
    suite << ActivityTest.suite
    suite << AppDataTest.suite
    suite << GroupTest.suite
    suite << PersonTest.suite
    suite << RpcRequestTest.suite
    suite << RequestTest.suite
    suite << ConnectionTest.suite
    suite << OnlineTest.suite
  end
end
Test::Unit::UI::Console::TestRunner.run(TS_AllTests)
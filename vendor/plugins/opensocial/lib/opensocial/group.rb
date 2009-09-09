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


module OpenSocial #:nodoc:
  
  # Acts as a wrapper for an OpenSocial group.
  #
  # The Group class takes input JSON as an initialization parameter, and
  # iterates through each of the key/value pairs of that JSON. For each key
  # that is found, an attr_accessor is constructed, allowing direct access
  # to the value. Each value is stored in the attr_accessor, either as a
  # String, Fixnum, Hash, or Array.
  #
  
  
  class Group < Base
    
    # Initializes the Group based on the provided json fragment. If no JSON
    # is provided, an empty object (with no attributes) is created.
    def initialize(json)
      if json
        json.each do |key, value|
          proper_key = key.snake_case
          begin
            self.send("#{proper_key}=", value)
          rescue NoMethodError
            add_attr(proper_key)
            self.send("#{proper_key}=", value)
          end
        end
      end
    end
  end
  
  # Provides the ability to request a Collection of groups for a given
  # user.
  #
  # The FetchGroupsRequest wraps a simple request to an OpenSocial
  # endpoint for a collection of groups. As parameters, it accepts
  # a user ID. This request may be used, standalone, by calling send, or
  # bundled into an RpcRequest.
  #
  
  
  class FetchGroupsRequest < Request
    # Defines the service fragment for use in constructing the request URL or
    # JSON
    SERVICE = 'groups'
    
    # Initializes a request to fetch groups for the specified user, or the
    # default (@me). A valid Connection is not necessary if the request is to
    # be used as part of an RpcRequest.
    def initialize(connection = nil, guid = '@me')
      super
    end
    
    # Sends the request, passing in the appropriate SERVICE and specified
    # instance variables.
    def send
      json = send_request(SERVICE, @guid)
      
      groups = Collection.new
      for entry in json['entry']
        group = Group.new(entry)
        groups[group.id] = group
      end
      
      return groups
    end
  end
end
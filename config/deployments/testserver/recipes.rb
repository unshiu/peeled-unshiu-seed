Capistrano::Configuration.instance.load do

  set :deployment_code, "testserver"
  
  env_path = []
  env_path << '/usr/local/bin:/usr/local/mysql/bin'
  env_path << '$PATH'
  default_environment['PATH'] = env_path.join(':')

  set :mongrel_rails, File.join(current_path, "script", "mongrel")

  set :gateway, "reference3.drecom.jp"
  set :ssh_options, :forward_agent => true, :port => 10022
  set :server_ssh_port, 10022
  
  role :app,        "192.168.50.151", :port => server_ssh_port
  role :web,        "192.168.50.151", :port => server_ssh_port
  role :db,         "192.168.50.151", :primary => true, :port => server_ssh_port
  role :memcached,  "192.168.50.151", :port => server_ssh_port
  role :backgroundrb, "192.168.50.151", :port => server_ssh_port
end

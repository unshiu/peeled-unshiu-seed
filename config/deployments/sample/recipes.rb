Capistrano::Configuration.instance.load do
  ENVIRONMENT = "sample"
  
  set :deployment_code, ENVIRONMENT
  
  env_path = []
  env_path << '/usr/local/bin:/usr/local/mysql/bin'
  env_path << '$PATH'
  default_environment['PATH'] = env_path.join(':')
  
  # -----------------------------------------------------------
  # Apache
  # -----------------------------------------------------------
  set :apache_server_admin,  "admin@unshiu.drecom.jp"
  set :apache_server_name,   "unshiu.drecom.jp"
  set :apache_max_clients,   200
  set :apache_stickysession, "_mobilesns_session_id"
  set :apache_use_ssl,       false
  
  # -----------------------------------------------------------
  # DB
  # -----------------------------------------------------------
  set :db_password, "root"
  set :db_user, "root"
  set :db_host, "127.0.0.1"
  
  # -----------------------------------------------------------
  # Mongrel
  # -----------------------------------------------------------
  set :mongrel_rails, File.join(current_path, "script", "mongrel")
  set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
  set :mongrel_clean, true
  set :mongrel_user, "drecom"
  set :mongrel_group, "drecom"
  set :mongrel_servers, "2"          # mongrel起動数
  set :mongrel_environment, ENVIRONMENT
  set :mongrel_port, "3000"
  set :mongrel_address, "127.0.0.1"
  
  # -----------------------------------------------------------
  # Memcache
  # -----------------------------------------------------------
  set :memcache_server, "127.0.0.1"

  # -----------------------------------------------------------
  # Backgroundrb
  # -----------------------------------------------------------
  set :backgroundrb_environment, ENVIRONMENT
  set :backgroundrb_host, "127.0.0.1"
  
  #set :gateway, "reference3.drecom.jp"
  #set :ssh_options, :forward_agent => true, :port => 10022
  set :server_ssh_port, 22
  
  role :app,        "127.0.0.1", :port => server_ssh_port
  role :web,        "127.0.0.1", :port => server_ssh_port
  role :db,         "127.0.0.1", :primary => true, :port => server_ssh_port
  role :memcached,  "127.0.0.1", :port => server_ssh_port
  role :backgroundrb, "127.0.0.1", :port => server_ssh_port
end

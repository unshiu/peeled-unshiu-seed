require 'singleton'
require 'yaml'

# AppResources[key] でアクセス可能
# 読み込むファイル名を RESOURCE_FILES に追加する必要がある
class AppResources
  include Singleton
  # 読み込むファイル名の一覧
  RESOURCE_FILES = ["base", "dia", "abm", "msg", 'cmm', 'tpc', 'mlg', 'mng', 'pnt']
  
  # resource file name
  RESOURCE_FILE_PREFIX = "#{RAILS_ROOT}/config/"  
  RESOURCE_FILE_SUFFIX = ".yml"
 
  # usage: AppResources["key_name"]
  def self.[](key)
    self.instance[key]
  end
  
  # usage: AppResources.instance["key_name"]
  def [](key)
    load if @app_resources == nil
    @app_resources[key]
  end

  # usage: AppResources.instance.load
  def load
    @app_resources = Hash.new
    for file in RESOURCE_FILES
      @app_resources[file] = YAML.load_file(RESOURCE_FILE_PREFIX + file + RESOURCE_FILE_SUFFIX)[RAILS_ENV]
    end
  end
end
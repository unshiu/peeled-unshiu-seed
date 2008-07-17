class MobileDispatchGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      m.class_collisions "DispatchController"
      m.directory 'app/controllers'
      m.template 'mobile_dispatch_controller.rb',
                 File.join('app/controllers',
                           'dispatch_controller.rb')
    end
  end

end

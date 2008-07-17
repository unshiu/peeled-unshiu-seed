class DispatchController < ApplicationController
  def default_controller; "top" end
  def default_action; "index" end

  def dispatch
    forward_to_controller(params)
  end

protected

  def forward_to_controller(options)
    klass = find_controller(options)
    options[:action] = find_action(options)
    request.instance_variable_set(
      :@parameters,
      (options || {}).with_indifferent_access.update(
        "controller" => klass.controller_name, "action" => options[:action] ) )
    request.instance_variable_set(
      :@request_parameters,
      (options || {}).with_indifferent_access.update(
        "controller" => klass.controller_name, "action" => options[:action] ) )

    resp = klass.process(request, response)
    if redirected = resp.redirected_to
      redirect_to redirected
    else
      render :text => resp.body
    end

  end

  def find_controller(options)
    options[:cont] ||= default_controller
    klass = "#{options[:cont].camelize}Controller".constantize
  end
  
  def find_action(options)
    action = options[:act] || default_action
  end


end

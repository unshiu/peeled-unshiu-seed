module ActionController
  module MobileUrlWriter
    mattr_accessor :default_url_options
    self.default_url_options = {}

    def self.included(base)
      ActionController::Routing::Routes.named_routes.install base
      base.mattr_accessor :default_url_options
      base.default_url_options ||= default_url_options
    end

    def url_for(options)
      options = self.class.default_url_options.merge(options)
      url = ''
      unless options.delete :only_path
        url << (options.delete(:protocol) || 'http')
        url << '://'
	url << ( options.delete(:host) || request.host_with_port )
	url << ":#{options.delete(:port)}" if options.key?(:port)
      else
        # Delete the unused options to prevent their appearance in the query string
        [:protocol, :host, :port].each { |k| options.delete k }
      end
      # overwrite controller and actions
      cont = ( options[:controller] || self.controller_name )
      act = ( options[:action] || "index" )
      options.merge!({:cont => cont.to_s, :act => act.to_s, :controller => "dispatch", :action => "dispatch"})
      url << Routing::Routes.generate(options, {})
      return url
    end
  end


  # Rewrites URLs for Base.redirect_to and Base.url_for in the controller.
  class UrlRewriter #:nodoc:

    RESERVED_OPTIONS = [:anchor, :params, :only_path, :host, :protocol, :trailing_slash, :skip_relative_url_root]
    def initialize(request, parameters)
      @request, @parameters = request, parameters
    end

    def rewrite(options = {})
      rewrite_url(rewrite_path(options), options)
    end

    def to_str
      "#{@request.protocol}, #{@request.host_with_port}, #{@request.path}, #{@parameters[:controller]}, #{@parameters[:action]}, #{@request.parameters.inspect}"
    end

    alias_method :to_s, :to_str

    private
      def rewrite_url(path, options)
        rewritten_url = ""
        unless options[:only_path]
          rewritten_url << (options[:protocol] || @request.protocol)
          rewritten_url << (options[:host] || @request.host_with_port)
        end

        rewritten_url << @request.relative_url_root.to_s unless options[:skip_relative_url_root]
        rewritten_url << path
        rewritten_url << '/' if options[:trailing_slash]
        rewritten_url << "##{options[:anchor]}" if options[:anchor]

        rewritten_url
      end

      def rewrite_path(options)
        options = options.symbolize_keys
        options.update(options[:params].symbolize_keys) if options[:params]
        if (overwrite = options.delete(:overwrite_params))
          options.update(@parameters.symbolize_keys)
          options.update(overwrite)
        end
	# rewrite controller and action
        cont = ( options[:controller] || @request.parameters[:controller] )
        act  = ( options[:action] || "index" )
        options.merge!({:cont => cont, :act => act, :controller => "dispatch", :action => "dispatch"})

        RESERVED_OPTIONS.each {|k| options.delete k}

        # Generates the query string, too
        Routing::Routes.generate(options, @request.symbolized_path_parameters)
      end

  end

end

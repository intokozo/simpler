require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'].each { |key, value| @request.update_param(key.to_sym, value)}

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def status(code)
      @response.status = code
    end

    def header(key, value)
      @response.set_header(key, value)
    end

    def write_response
      content = render_response

      @response.write(content[:body])
      @response['Content-Type'] = content[:type]
      @response['template'] = content[:template]
    end

    def render_response
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def render(source)
      @request.env['simpler.render_source'] = source
    end

  end
end

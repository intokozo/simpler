module Simpler
  class PlainRender

    TYPE = 'text/plain'

    def initialize(env)
      @env = env
    end

    def result(binding)
      {type: TYPE,
       body: @env['simpler.render_source'].values.first,
       template: ''}
    end
  end
end


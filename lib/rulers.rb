require "rulers/version"
require "rulers/routing"

module Rulers
  class Application
    def call(env)
      `echo debug > debut.txt`;

      if env["PATH_INFO"] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      elsif env["PATH_INFO"] == "/"
        # temporary rerouting to google
        return [302, {'Location' => "http://google.com"}, []]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)

      begin
        text = controller.send(act)
      rescue
        # what to do if action doesn't exist
        text = "ERROR"
      end

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end

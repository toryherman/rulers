require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

module Rulers
  class Application
    def call(env)
      `echo debug > debug.txt`;

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
end

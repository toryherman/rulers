require_relative "test_helper"

class TestController < Rulers::Controller
  def index
    "Hello"
  end
end

class TestApp < Rulers::Application
  def get_controller_and_action(env)
    [TestController, "index"]
  end
end

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/example/route"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end

  def test_headers
    get "/example/route"

    assert last_response.ok?
    headers = last_response.headers['Content-Type']
    assert headers["text/html"]
  end

  def test_status
    get "/example/route"

    assert last_response.ok?
    status = last_response.status
    assert status[200]
  end
end

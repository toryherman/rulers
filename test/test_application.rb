require_relative "test_helper"

class TestApp < Rulers::Application
end

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end

  def test_headers
    get "/"

    assert last_response.ok?
    headers = last_response.headers['Content-Type']
    assert headers["text/html"]
  end

  def test_status
    get "/"

    assert last_response.ok?
    status = last_response.status
    assert status[200]
  end
end

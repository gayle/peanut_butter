require_relative 'schedule'
require 'test/unit'
require 'rack/test'
require 'sinatra'

ENV['RACK_ENV'] = 'test'

class ScheduleTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_does_something
    get '/'
    assert last_response.ok?
    assert !last_response.body.empty?, "response should have some content"
  end
end
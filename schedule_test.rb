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
    assert_match /Hi world/i, last_response.body
  end
end
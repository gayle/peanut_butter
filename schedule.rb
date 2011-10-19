require 'sinatra'

get '/' do
  "Hi world, it's #{Time.now} at the server!"
end
require 'rubygems'

# If you're using bundler, you will need to add this
require 'bundler/setup'

require 'sinatra'

get '/' do
  "Hello world, it's #{Time.now} at the server!"
end
require 'rubygems'
require 'bundler'

Bundler.require

require './app.rb'

# map a directory including a directory listing
map "/public" do
    run Rack::Directory.new("./public")
end

run Sinatra::Application

require "dotenv"
Dotenv.load

require "sinatra"
require "mongo"

mongo = Mongo::Client.new([ENV["MONGODB_HOST"]], database: ENV["MONGODB_DB"])

get "/" do
  "Hello, world!"
end

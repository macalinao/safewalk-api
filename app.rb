require "dotenv"
Dotenv.load

require "sinatra"
require "mongo"
require "json"

db = Mongo::Client.new([ENV["MONGODB_HOST"]], database: ENV["MONGODB_DB"])

get "/" do
  "Hello, world!"
end

get "/pois" do
  pois = []
  db[:pois].find.each do |poi|
    pois << poi
  end
  pois.to_json
end

post "/pois" do
  # db[:pois].insert_one(
  json = JSON.parse(request.body.string)
  json["test"]
end

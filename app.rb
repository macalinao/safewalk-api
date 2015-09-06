require "dotenv"
Dotenv.load

require "sinatra"
require "mongo"
require "json"
require "unirest"

db = Mongo::Client.new([ENV["MONGODB_HOST"]], database: ENV["MONGODB_DB"])

set :bind, "0.0.0.0"
set :port, ENV["PORT"]
set :public_folder, Proc.new { File.join(root, "public") }
set :static, true

before do
  content_type :json
end

get "/" do
  redirect to("/public/splash.html")
end

get "/pois" do
  pois = []
  db[:pois].find.each do |poi|
    pois << poi
  end
  pois.to_json
end

post "/pois" do
  begin
    json = JSON.parse(request.body.string)
  rescue e
    status 400
    next body "Invalid POI"
  end
  result = db[:pois].insert_one(json)
  { success: result.successful? }.to_json
end

get "/directions" do
  origin = params[:origin] || "Wells Fargo Center Philadelphia"
  destination = params[:destination] || "Liberty Bell Philadelphia"
  oe = URI.escape(origin)
  de = URI.escape(destination)
  url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{oe}&destination=#{de}&mode=walking"
  Unirest.get(url).raw_body
end

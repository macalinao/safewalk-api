require "dotenv"
Dotenv.load

require "net/http"
require "json"
require "unirest"

API_BASE = "https://api.everyblock.com"
CITY = "philly"
FILE = "everyblock_data.json"
TOKEN = ENV["EVERYBLOCK_API_KEY"]

class EveryBlockData

  def main
    json = CrimeReader.new(zipcodes).read_all.to_json
    File.open(FILE, 'w') { |file| file.write(json) }
  end

  def zipcodes
    JSON.parse(zipcodes_raw).map { |el| el["name"] }
  end

  def zipcodes_raw
    Unirest.get("#{API_BASE}/content/#{CITY}/zipcodes", headers: {
      Authorization: "Token #{TOKEN}",
      Accept: "application/json"
    }).raw_body
  end

end

class CrimeReader

  attr_reader :zipcodes

  def initialize(zipcodes)
    @zipcodes = zipcodes
  end

  def read_all
    zipcodes.map do |zipcode|
      puts "Getting data for zipcode #{zipcode}"
      ZipCodeCrime.new(zipcode).first_results
    end.flatten
  end

end

class ZipCodeCrime

  attr_reader :zipcode

  def initialize(zipcode)
    @zipcode = zipcode
  end

  def first_results
    data["results"].map do |result|
      {
        title: result["title"],
        location: result["location_name"]
      }
    end
  end

  def data
    Unirest.get(endpoint, headers: {
      Authorization: "Token #{TOKEN}",
      Accept: "application/json"
    }).body
  end

  def endpoint
    "#{API_BASE}/content/#{CITY}/locations/#{zipcode}/timeline/?schema=crime"
  end

end

EveryBlockData.new.main

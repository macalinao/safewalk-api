require "dotenv"
Dotenv.load

require "net/http"
require "json"
require "unirest"

API_BASE = "https://api.everyblock.com"
CITY = "philly"
FILE = "data/everyblock_data.json"
TOKEN = ENV["EVERYBLOCK_API_KEY"]

class EveryBlockData

  def main
    # json = CrimeReader.new(zipcodes).read_all.to_json
    json = ZipCodeCrime.new("19148").results.to_json
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
    results(1)
  end

  def results(total = 50)
    ret = []
    stop = false
    total.times do |n|
      next if stop
      puts "Getting page #{n + 1}"
      data_ret = data(n + 1)
      if !data_ret["results"]
        stop = true
        next
      end
      ret = ret.concat(data_ret["results"].map do |result|
        {
          title: result["title"],
          location: result["location_name"]
        }
      end)
    end
    ret
  end

  def data(page = nil)
    url = endpoint
    url += "&page=#{page}" if page
    begin
      resp = Unirest.get(url, headers: {
        Authorization: "Token #{TOKEN}",
        Accept: "application/json"
      })
    rescue e
      return nil
    end
    resp.body
  end

  def endpoint
    "#{API_BASE}/content/#{CITY}/locations/#{zipcode}/timeline/?schema=crime"
  end

end

EveryBlockData.new.main

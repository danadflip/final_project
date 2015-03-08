module Drive
  class Server < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      $redis = Redis.new
    end

    configure :production do
      $redis = Redis.new({url: ENV['REDISTOGO_URL']})
    end


    get("/") do

      render(:erb, :index, { :layout => :default_layout })
    end

    get('/weather') do
      response_by_coordinates = HTTParty.get("http://api.wunderground.com/api/d9ccd086534d5989/geolookup/q/#{params["startLat"]},#{params["startLong"]}.json")
      requesturl = response_by_coordinates["location"]["requesturl"]
      response_by_city = HTTParty.get("http://api.wunderground.com/api/d9ccd086534d5989/hourly/q/#{requesturl}.json")
      # weather conditions:
      condition = response_by_city["hourly_forecast"][0]["condition"]
      temp = response_by_city["hourly_forecast"][0]["temp"]
      snow = response_by_city["hourly_forecast"][0]["snow"]
      weather_report = {condition: condition, snow: snow, temp: temp}

      # render(json: temp)
      weather_report.to_json
    end


  end
end

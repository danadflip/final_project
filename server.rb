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
      # first location
      first_response_by_city = HTTParty.get("http://api.wunderground.com/api/d9ccd086534d5989/hourly/q/#{params["startLat"]},#{params["startLong"]}.json")
      # weather conditions:
      first_condition = first_response_by_city["hourly_forecast"][0]["condition"]
      first_temp = first_response_by_city["hourly_forecast"][0]["temp"]
      first_snow = first_response_by_city["hourly_forecast"][0]["snow"]

      # last location
      last_response_by_city = HTTParty.get("http://api.wunderground.com/api/d9ccd086534d5989/hourly/q/#{params["endLat"]},#{params["endLong"]}.json")
      # weather conditions:
      last_condition = last_response_by_city["hourly_forecast"][0]["condition"]
      last_temp = last_response_by_city["hourly_forecast"][0]["temp"]
      last_snow = last_response_by_city["hourly_forecast"][0]["snow"]

    params["durationOfTripInSeconds"]






      first_weather_report = {first_condition: first_condition, first_snow: first_snow, first_temp: first_temp, last_temp: last_temp, last_snow: last_snow, last_condition: last_condition}
      binding.pry
      # render(json: temp)
      first_weather_report.to_json
    end


  end
end

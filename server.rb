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
      get_weather_at(
        params["lat"],
        params["long"],
        params["secondsFromNow"].to_i
        # params["order"]
      ).to_json
    end


    def get_weather_at(lat, long, seconds_from_now)
      url    = "http://api.wunderground.com/api/" + ENV["WEATHER_UNDERGROUND_API"] +"/hourly/q"
      params = "/#{lat},#{long}.json"

      url_2 = "http://api.wunderground.com/api/" + ENV["WEATHER_UNDERGROUND_API"] +"/geolookup/q"
      wu_api_response = HTTParty.get(url+params)
      wu_api_city_response = HTTParty.get(url_2 + params)

      hours_from_now = seconds_from_now/3600
      # api only gives 35 hour forecast
      hours_from_now = 35 if hours_from_now > 35



      # return a hash of weather conditions
      {
        hours_from_now: hours_from_now,
        condition:      wu_api_response["hourly_forecast"][hours_from_now]["condition"],
        temp:           wu_api_response["hourly_forecast"][hours_from_now]["temp"],
        snow:           wu_api_response["hourly_forecast"][hours_from_now]["snow"],
        rain:           wu_api_response["hourly_forecast"][hours_from_now]["qpf"],
        precip:         wu_api_response["hourly_forecast"][hours_from_now]["pop"],
        city:           wu_api_city_response["location"]["city"]
        # order:          order
      }

      #       {
      #   hours_from_now: 10,
      #   condition:      "Cloudy",
      #   temp:           45,
      #   snow:           4,
      #   rain:           3,
      #   precip:         30
      #   # order:          order
      # }
    end
  end
end

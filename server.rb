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
      url    = "http://api.wunderground.com/api/d9ccd086534d5989/hourly/q"
      params = "/#{lat},#{long}.json"

      wu_api_response = HTTParty.get(url+params)

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
        precip:         wu_api_response["hourly_forecast"][hours_from_now]["pop"]
        # order:          order
      }
    end
  end
end

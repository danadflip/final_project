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
      first_rain = first_response_by_city["hourly_forecast"][0]["qpf"]
      first_percent_of_percip = first_response_by_city["hourly_forecast"][0]["pop"]


# include an if statement that says if duration of a step is >25 miles, give a weather report





      # last location
      last_response_by_city = HTTParty.get("http://api.wunderground.com/api/d9ccd086534d5989/hourly/q/#{params["endLat"]},#{params["endLong"]}.json")
      # actual hour that arrive at destination
      duration_before_convert = params["durationOfTripInSeconds"].to_i
      duration_converted = duration_before_convert/3600
        # conditional statement necessary because api only gives 35 hour forecast, anything above will return nil
        if duration_converted>35
          duration_converted=35
        end

      # binding.pry
# every hour/hour and a half of trip time have a forecast call = once you have the total number of forecasts -

# at this point the duration is above

      # weather conditions:
      last_condition = last_response_by_city["hourly_forecast"][duration_converted]["condition"]
      last_temp = last_response_by_city["hourly_forecast"][duration_converted]["temp"]
      last_snow = last_response_by_city["hourly_forecast"][duration_converted]["snow"]
      last_rain = last_response_by_city["hourly_forecast"][duration_converted]["qpf"]
      last_percent_of_percip = last_response_by_city["hourly_forecast"][duration_converted]["pop"]



      # prepares variables for javascript
      weather_report = {
        first_condition: first_condition,
        first_snow: first_snow,
        first_temp: first_temp,
        first_rain: first_rain,
        first_percent_of_percip: first_percent_of_percip,
        last_temp: last_temp,
        last_snow: last_snow,
        last_condition: last_condition,
        last_rain: last_rain,
        last_percent_of_percip: last_percent_of_percip
      }


      # render(json: temp)
      weather_report.to_json
    end


  end
end

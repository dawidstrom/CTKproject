require 'net/http'

class MapController < ApplicationController
  def index
	  # Get the API key for Google Maps Javascript API.
	  gmapkey = File.read("#{Rails.root}/app/assets/gmapsapi.key")

	  # Get the API key for OpenWeatherAPI.
	  openweatherkey = File.read("#{Rails.root}/app/assets/openweatherapi.key")
	  @map = "https://maps.googleapis.com/maps/api/js?key=#{gmapkey}&callback=startMap"

	  # Get the cities to check polution and weather data for.
	  cities = File.read("#{Rails.root}/app/assets/cities")
	  cities = cities.split("\n")

	  # Retrieve weather and polution information about cities.
	  # Use downloaded json files to not excessivly tax the API system.
	  @weather = Hash.new(cities.size)
	  cities.each do |city|

		  # Get weather information from weather api for city.
		  weather_info = "http://api.openweathermap.org/data/2.5/forecast?q="+city+"&APPID="+openweatherkey
		  url = URI.parse(weather_info)
		  req = Net::HTTP::Get.new(url.to_s)
		  res = Net::HTTP.start(url.host, url.port) {|http|
			  http.request(req)
		  }

		  # Save and parse the result of the query.
		  res = res.body
		  res = JSON.parse res

=begin    Used to avoid excessive API calls during development.
		  # Format city so it is easier to get the downloaded json files.
		  city_formatted = city.dup
		  city_formatted.gsub! ' ','_'
		  city_formatted = city_formatted.split(',')

		  # Retrieve the json file for this particular city and parse it.
		  res = File.read("#{Rails.root}/app/assets/"+city_formatted[0]+".json")
		  res = JSON.parse res
=end

		  # Gather weather information.
		  weather_info = Array.new(5)
		  # Retrieve weather information.
		  weather_info[0] = res['list'][0]['weather'][0]['main']
		  # Retrieve temperature and convert it from Kelvin to Celsius, round
		  # the result to nearest two decimals.
		  weather_info[1] = (res['list'][0]['main']['temp']-273.15).round(2)
		  # Retrieve wind speed.
		  weather_info[2] = res['list'][0]['wind']['speed']
		  # Extract lat, long coordinates for city.
		  weather_info[3] = res['city']['coord']['lat'].round(3)
		  weather_info[4] = res['city']['coord']['lon'].round(3)

		  # Make the retrieved information accessible to the view.
		  @weather[city] = weather_info
	  end
  end

  def getWeatherInfo
	  query = params[:city_query]
	  parsed_query = query.split(',')

	  # Get the API key for Google Maps Javascript API.
	  gmapkey = File.read("#{Rails.root}/app/assets/gmapsapi.key")

	  # Get the API key for OpenWeatherAPI.
	  openweatherkey = File.read("#{Rails.root}/app/assets/openweatherapi.key")

	  # Safely checks if the provided query is numeric or not.
	  isNumerics = Float(parsed_query[0]) != nil and Float(parsed_query[1]) != nil rescue false

	  # Determine if coordinates or city,country abbreviation should be used for 
	  # API request.
	  if isNumerics
	  	openweather_url = "http://api.openweathermap.org/data/2.5/forecast?lat=#{parsed_query[0]}&lon=#{parsed_query[1]}&APPID="+openweatherkey
	  else
	  	openweather_url = "http://api.openweathermap.org/data/2.5/forecast?q=#{query}&APPID="+openweatherkey
	  end

	  #@map = "https://maps.googleapis.com/maps/api/js?key=#{gmapkey}&callback=startMap"

	  # Retrieve weather information about coordinate or city.
	  url = URI.parse(openweather_url)
	  req = Net::HTTP::Get.new(url.to_s)
	  res = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(req)
	  }

	  puts openweather_url

	  # Save and parse the query result.
	  res = res.body
	  res = JSON.parse res

	  weather_info = Array.new(5)
	  # Retrieve weather information.
	  weather_info[0] = res['list'][0]['weather'][0]['main']
	  # Retrieve temperature and convert it from Kelvin to Celsius, round
	  # the result to nearest two decimals.
	  weather_info[1] = (res['list'][0]['main']['temp']-273.15).round(2)
	  # Retrieve wind speed.
	  weather_info[2] = res['list'][0]['wind']['speed']
	  # Extract lat, long coordinates for city. Round to 3 since openweatherapi
	  # can't process requests with more than 3 decimals for coordinates.
	  weather_info[3] = res['city']['coord']['lat'].round(3)
	  weather_info[4] = res['city']['coord']['lon'].round(3)

	  # Combine the city name and weather information.
	  weather = Hash.new(1)

	  city = res['city']['name']+','+res['city']['country']
	  weather[city] = weather_info

	  puts weather

	  # Respond to AJAX with json of the hashed information.
	  # Currently not working correctly.
	  respond_to do |format|
		  format.json do
			  render json: weather
		  end
	  end
  end

end

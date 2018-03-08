require 'net/http'

class MapController < ApplicationController
  def index
	  # Get the API key for Google Maps Javascript API.
	  gmapkey = File.read("#{Rails.root}/app/assets/gmapsapi.key")
	  @map = "https://maps.googleapis.com/maps/api/js?key=#{gmapkey}&callback=initMap"

	  # Get the API key for OpenWeatherAPI.
	  openweatherkey = File.read("#{Rails.root}/app/assets/openweatherapi.key")


	  # Get the cities to check polution and weather data for.
	  cities = File.read("#{Rails.root}/app/assets/cities")
	  cities = cities.split("\n")

	  # Retrieve weather and polution information about cities.
	  # Use downloaded json files to not excessivly tax the API system.
	  @weather = Hash.new(cities.size)
	  cities.each do |city|
		  # Format city so it is easier to get the downloaded json files.
		  city_formatted = city.dup
		  city_formatted.gsub! ' ','_'
		  city_formatted = city_formatted.split(',')

		  # Retrieve the json file for this particular city and parse it.
		  res = File.read("#{Rails.root}/app/assets/"+city_formatted[0]+".json")
		  res = JSON.parse res

		  arr = Array.new(3)
		  # Retrieve weather information.
		  arr[0] = res['list'][0]['weather'][0]['main']
		  # Retrieve temperature and convert it from Kelvin to Celsius, round
		  # the result to nearest two decimals.
		  arr[1] = (res['list'][0]['main']['temp']-273.15).round(2)
		  # Retrieve wind speed.
		  arr[2] = res['list'][0]['wind']['speed']

		  # Make the retrieved information accessible to the view.
		  @weather[city] = arr
	  end

=begin
	  # Don't perform excessive API calls during development.
	  @cities.each do |city|
		  str = "http://api.openweathermap.org/data/2.5/forecast?q="+city+"&APPID="+openweatherkey
		  url = URI.parse(str)
		  req = Net::HTTP::Get.new(url.to_s)
		  res = Net::HTTP.start(url.host, url.port) {|http|
			  http.request(req)
		  }
		  res = res.body
		  res = JSON.parse res
		  @data[city] = res['list'][0]['weather'][0]['main']
	  end
=end
  end
end

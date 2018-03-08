require 'net/http'

class MapController < ApplicationController
  def index
	  # Get the API key for OpenWeatherAPI.
	  key = File.read("#{Rails.root}/app/assets/api.key")

	  # Get the cities to check polution and weather data for.
	  cities = File.read("#{Rails.root}/app/assets/cities")
	  cities = cities.split("\n")

	  # Retrieve weather and polution information about cities.
	  # Use downloaded json files to not excessivly tax the API system.
	  @weather = Hash.new(cities.size)
	  cities.each do |city|
		  # Format city so it is easier to get the downloaded json files.
		  city_formatted = city
		  city_formatted.gsub! ' ','_'
		  city_formatted = city_formatted.split(',')

		  # Retrieve the json file for this particular city and parse it.
		  res = File.read("#{Rails.root}/app/assets/"+city_formatted[0]+".json")
		  res = JSON.parse res

		  # Make the retrieved information accessible to the view.
		  @weather[city] = res['list'][0]['weather'][0]['main']
	  end

=begin
	  # Don't perform excessive API calls during development.
	  @cities.each do |city|
		  str = "http://api.openweathermap.org/data/2.5/forecast?q="+city+"&APPID="+key
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

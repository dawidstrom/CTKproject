require 'net/http'

class MapController < ApplicationController
  def index
	  key = File.read("#{Rails.root}/app/assets/api.key")

	  url = URI.parse('http://api.openweathermap.org/data/2.5/forecast?q=Gothenburg,se&APPID='+key)
	  req = Net::HTTP::Get.new(url.to_s)
	  res = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(req)
	  }

	  puts res.body
  end
end

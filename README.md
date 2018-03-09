# README

This is a website hosting a weather map and weather information for various 
cities in the world, made on behalf of CTK.

The code have been developed on an Arch Linux system running:

Ruby version: 2.5

Rails version: 5.1.5


To run the project:
1. Clone this repository.
2. Get an API key from "openweathermap.org" and put it in the file app/assets/openweatherapi.key.
2. Get an API key from "developers.google.com/maps" and put it in the file app/assets/gmapsapi.key.
3. Specify which cities you would like to have data for by putting "\<City
   name\>,\<Country abbreviation\>" in the file named app/assets/cities. 
   Separate each city with a newline.
4. Run "rails s" in the projects root folder and go to "localhost:3000".

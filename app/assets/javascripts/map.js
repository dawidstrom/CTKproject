/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

// Starting location, Gothenburg,se.
var x = 57.71;
var y = 11.98;

// Function for initializing a google map using the Google Maps Javascript API.
function initMap() { 
	var uluru = { lat: x, lng: y};
	var map = new google.maps.Map(document.getElementById('map'), { zoom: 7, center: uluru }); 
	var marker = new google.maps.Marker({ position: uluru, map: map }); 
}

/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

// Starting location, Gothenburg,se.
var start_x = 57.71;
var start_y = 11.98;

// Sets the element with id "map" to be a Google Maps map, with position x and
// y.
function initMap(x, y) { 
	var uluru = { lat: x, lng: y};
	var map = new google.maps.Map(document.getElementById('map'), { zoom: 7, center: uluru }); 
	var marker = new google.maps.Marker({ position: uluru, map: map }); 
}

// 
function updateMapOnEnter(key) {
	if (key == 13) {
		document.getElementById('city_query_submit').click();
	}
}

// Update map with input.
function updateMapWithInput() {
	input = document.getElementById('city_query').value.split(',');
	initMap(parseFloat(input[1]), parseFloat(input[0]));
}

// Initializes 
function startMap() {
	initMap(start_x, start_y);
}

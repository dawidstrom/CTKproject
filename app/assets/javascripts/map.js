/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

// Starting location, Gothenburg,se.
var start_x = 57.71;
var start_y = 11.98;

var prev_placeholder = "<City>,<Country Abbreviation>";
var new_placeholder = "<Longitude>,<Latitude>";

// Periodically change the placeholder text in the city query textfield.
setInterval(function() {
	document.getElementById('city_query').placeholder = new_placeholder;
	var tmp = new_placeholder;
	new_placeholder = prev_placeholder;
	prev_placeholder = tmp;
}, 3000);

// Sets the element with id "map" to be a Google Maps map, with position x and
// y.
function setMapByCoordinates(x, y) { 
	var uluru = { lat: x, lng: y};
	var map = new google.maps.Map(document.getElementById('map'), { zoom: 7, center: uluru }); 
	var marker = new google.maps.Marker({ position: uluru, map: map }); 
}

// Set the element with id "map" be a Google Maps map, with position based on
// city name and country abbreviation.
function setMapByCityAndCountry(city, country) {
	// Todo
	alert('This should set map by city and country');
}

// Makes the Enter key trigger a click.
function updateMapOnEnter(key) {
	if (key == 13) {
		document.getElementById('city_query_submit').click();
	}
}

// Update map with input.
function updateMapWithInput() {
	input = document.getElementById('city_query').value

	if (input == null || input == "") {
		setMapByCoordinates(start_x, start_y);
		return;
	}

	input = input.split(',');
	// If both values are number, try set map by coordinates.
	// If neither value is a number, try set map by city name and country
	// abbreviation.
	// Else throw an error.
	if (isNumber(input[0]) && isNumber(input[1])) {
		setMapByCoordinates(parseFloat(input[1]), parseFloat(input[0]));
	} else if(isNaN(input[0]) && isNaN(input[1])) {
		setMapByCityAndCountry(input[0], input[1]);
	} else {
		// Flash some informative error.
		alert("The query you've entered have incorrect format.");
	}
}

// Helper function to test if some variable is a number.
function isNumber(val) {
	return !isNaN(parseFloat(val)) && isFinite(val);
}

// Initializes 
function startMap() {
	setMapByCoordinates(start_x, start_y);
}

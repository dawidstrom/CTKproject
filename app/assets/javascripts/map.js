/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

// Starting location, Gothenburg,se.
var start_x = 57.71;
var start_y = 11.98;

// Placeholder text for city weather query.
var prev_placeholder = "<City>,<Country Abbreviation>";
var new_placeholder = "<Longitude>,<Latitude>";


// Wait for the document (and JQuery) to become ready.
window.onload = function() {
	// Set CSRF header in all ajax requests.
	$.ajaxSetup({
		headers: {
			'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
		}
	});
}


// Periodically change the placeholder text in the city query textfield.
setInterval(function() {
	document.getElementById('city_query').placeholder = new_placeholder;

	// Swap the placeholder values.
	var tmp = new_placeholder;
	new_placeholder = prev_placeholder;
	prev_placeholder = tmp;
}, 3000);


// Sets the element with id "map" to be a Google Maps map, with position x and
// y.
function setMapByCoordinates(x, y) { 
	// The current weather information for selected city.
	var weather_info = '<h3>Weather Information not present at this time.</h3>';

	// Setting the map to view the current city.
	var uluru = { lat: x, lng: y};
	var map = new google.maps.Map(document.getElementById('map'), { zoom: 10, center: uluru }); 
	var marker = new google.maps.Marker({ position: uluru, map: map }); 

	// Adds a info window to the marker, displaying weather info.
	var info_window = new google.maps.InfoWindow({
		content: weather_info
	});

	// Open window on click.
	marker.addListener('click', function() {
		info_window.open(map, marker);
	});
}


// Set the element with id "map" be a Google Maps map, with position based on
// city name and country abbreviation.
function setMapByCityAndCountry(city, country) {
	$.post({
		url: "/map/test",
		type: "post",
		data: { city:city, country:country },
		success: function() {
			// Replace weather data and map with those received from server call.
			alert('success');
		},
		error: function() {
			alert('error occured when setting map by city and country');
		}
	});
}


// Makes the Enter key trigger a click.
function updateMapOnEnter(key) {
	// Enter has keyCode 13.
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


// Sets the starting map.
function startMap() {
	setMapByCoordinates(start_x, start_y);
}

// Helper function to test if some variable is a number.
function isNumber(val) {
	return !isNaN(parseFloat(val)) && isFinite(val);
}

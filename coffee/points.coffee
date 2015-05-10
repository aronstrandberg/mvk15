"use strict"

# creates an empty data structure to hold data for plotting
reset = ->
  id: []
  velocity: []
  altitude: []
  latitude: []
  longitude: []

# if window.running is false, we should not continue to fetch new data
window.running = true
# how often should we poll for new data?
window.interval = 1000
# creates an empty data structure to hold data for plotting
window.data = reset()

# creates the variable which will hold the Google maps object
map = undefined

# the google maps styling object. sets the map's color scheme and hides irrelevant metadata
mapStyle = [{
    "featureType": "administrative",
    "elementType": "labels",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [{
        "color": "#DCE7EB"
    }]
}, {
    "featureType": "administrative.country",
    "elementType": "labels.text",
    "stylers": [{
        "visibility": "on"
    }, {
        "color": "#000000"
    }]
}, {
    "featureType": "administrative.country",
    "elementType": "labels.icon",
    "stylers": [{
        "visibility": "on"
    }, {
        "color": "#000000"
    }]
}, {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [{
        "color": "#DCE7EB"
    }]
}, {
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [{
        "visibility": "on"
    }]
}, {
    "featureType": "landscape.natural",
    "elementType": "labels",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "poi",
    "elementType": "all",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "road",
    "elementType": "all",
    "stylers": [{
        "visibility": "off"
    }]
}, {
  "featureType": "road",
  "elementType": "geometry",
  "stylers": [{
      "visibility": "simplified"
    }]
}, {
    "featureType": "road",
    "elementType": "labels",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "transit",
    "elementType": "labels.icon",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "transit.line",
    "elementType": "labels.text",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "transit.station.airport",
    "elementType": "geometry",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "transit.station.airport",
    "elementType": "labels",
    "stylers": [{
        "visibility": "off"
    }]
}, {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{
        "color": "#83888B"
    }]
}, {
    "featureType": "water",
    "elementType": "labels",
    "stylers": [{
        "visibility": "off"
    }]
}]

# configuration options for the map
mapOptions = {
  center: {
    lat: 59.34806
    lng: 18.07142
  }
  zoom: 17
  styles: mapStyle
  disableDefaultUI: true
  mapMaker: true
  minZoom: 10
}

# function that sets the styling of the points (color and size, primarily)
styleFeature = (feature) ->
  # color of 1.0
  low = [134, 91, 50]
  # color of 6.0 and above
  high = [0, 100, 50]
  min = 1.0
  max = 10.0
  # fraction represents where the value sits between the min and max
  fraction = (Math.min(feature.getProperty('velocity'), max) - min) / (max - min)
  color = interpolateHsl(low, high, fraction)
  scale = 250/map.getZoom()
  id = feature.getProperty("id")
  z = id
  # every 10th point is larger and has a higher z-index, so we modify the other 9
  if id % 10 != 0
    # color = "#ccc"
    scale = 100/map.getZoom()
    z = z/5
  return {
    icon: {
      path: google.maps.SymbolPath.CIRCLE
      strokeWeight: 1.25
      strokeColor: "#fff"
      fillColor: color
      fillOpacity: 0.95
      scale: scale
    }
    zIndex: z
  }

# calculate a color based on the fraction
interpolateHsl = (lowHsl, highHsl, fraction) ->
  color = []
  i = 0
  while i < 3
    # Calculate color based on the fraction.
    color[i] = (highHsl[i] - lowHsl[i]) * fraction + lowHsl[i]
    i++
  "hsl(#{color[0]}, #{color[1]}%, #{color[2]}%)"

id = -1

# poll for new data and add new points to the map
fetch = ->
  if !window.running
    return
  json = {}
  # lap = 19
  # jquery method to perform an AJAX request
  $.ajax
    # we send a GET request to our PHP script
    url: "/php/main.php"
    type: "GET"
    # we send the id of the latest recieved point as data to the request in order to only poll for new points
    data:
      # lap: lap
      id: id
    # callback function executed on a successful request
    success: (data, code, xhr) ->
      # http code 204 means there is no new data: abort for now
      if xhr.status == 204
        return
      # parse the json string into a javascript object
      json = JSON.parse(data)
      # abort if json is null
      if !json?
        return
      # window.data = reset()

      # add the returned data to the data object. this is used to plot data in the graph
      for point in json.features
        for property in ["id", "velocity", "altitude", "latitude", "longitude"]
          window.data[property].push point.properties[property]
      # update the id variable to the last point received
      id = json.features[json.features.length-1].properties.id
      # adds the received points to the map using the google maps API
      map.data.addGeoJson(json)

    # callback function executed when the request returns an error
    error: (error) ->
      console.log error
    # complete: (xhr) ->
      # console.log xhr.status

    # callback function that executes based on the request's http return code
    statusCode:
      205: ->
        window.running = false
  return json

google.maps.event.addDomListener window, 'load', ->
  # creates the map object
  map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)
  # set the data styling function to the styleFeature function defined above
  map.data.setStyle styleFeature
  # add a mouse hover event that updates the infobox when hovering over a point
  map.data.addListener 'mouseover', (event) ->
    document.getElementById('latitude').textContent  = event.feature.getGeometry().get().lat().round(5)
    document.getElementById('longitude').textContent = event.feature.getGeometry().get().lng().round(5)
    document.getElementById('velocity').textContent  = event.feature.getProperty("velocity").round(2)
    document.getElementById('altitude').textContent  = event.feature.getProperty("altitude")
    document.getElementById('timestamp').textContent  = new Date(event.feature.getProperty("timestamp")).toLocaleString()
    return
  map.data.addListener 'click', (event) ->
    map.panTo
      lat: event.feature.getGeometry().get().lat()
      lng: event.feature.getGeometry().get().lng()
  return

# calls the fetch function to poll for new data at the specified interval
$ ->
  setInterval(fetch, window.interval)

# function to round numbers for display in the infobox
Number.prototype.round = (places) ->
  return +(Math.round(this + "e+" + places)  + "e-" + places)

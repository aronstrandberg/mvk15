"use strict"

# variables
window.running = true
window.interval = 1000

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

map = undefined
mapOptions = {
  center: {
    lat: 59.346659
    lng: 18.072063
  }
  zoom: 18
  styles: mapStyle
  disableDefaultUI: true
  mapMaker: true
  minZoom: 10
}

styleFeature = (feature) ->
  # color of mag 1.0
  low = [134, 91, 50]
  # color of mag 6.0 and above
  high = [0, 100, 50]
  min = 1.0
  max = 12.0
  # fraction represents where the value sits between the min and max
  fraction = (Math.min(feature.getProperty('velocity'), max) - min) / (max - min)
  color = interpolateHsl(low, high, fraction)
  return {
    icon: {
      path: google.maps.SymbolPath.CIRCLE
      strokeWeight: 2
      strokeColor: "#eee"
      fillColor: color
      fillOpacity: 1
      scale: 15
    }
    zIndex: Math.floor(feature.getProperty('id'))
  }

interpolateHsl = (lowHsl, highHsl, fraction) ->
  color = []
  i = 0
  while i < 3
    # Calculate color based on the fraction.
    color[i] = (highHsl[i] - lowHsl[i]) * fraction + lowHsl[i]
    i++
  "hsl(#{color[0]}, #{color[1]}%, #{color[2]}%)"

fetch = () ->
  $.ajax
    url: "lol.php"
    type: "GET"
    success: (data) ->
      console.log "success"
      console.log data
      js = JSON.parse(data)
      map.data.addGeoJson(js)
    error: (error) ->
      console.log "error"
      console.log error
  false

addPoints = ->
  if !window.running
    return
  # fetch new points 
  fetch()
  
  # pan to the new blip
  # todo: pan only when neccessary
  map.panTo({
    lat: lat
    lng: lng
  })
  return

google.maps.event.addDomListener window, 'load', ->
  map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)
  map.data.setStyle styleFeature
  map.data.addListener 'mouseover', (event) ->
    document.getElementById('info').textContent = event.feature.getProperty('velocity')
    return
  return


$('*').click ->
  window.running = !window.running
$ ->
  setInterval(addPoints, window.interval)

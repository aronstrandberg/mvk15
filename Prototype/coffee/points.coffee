"use strict"

# variables
window.running = true
window.interval = 1000
map = undefined

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

mapOptions = {
  center: {
    lat: 59.34714
    lng: 18.07292
  }
  zoom: 17
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
      fillOpacity: 0.95
      scale: 15
    }
    zIndex: feature.getProperty('id')
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
  json = {}
  $.ajax
    url: "lol.php"
    type: "GET"
    success: (data) ->
      json = JSON.parse(data)
      console.log json
      window.data = []
      for point in json.features
        do (point) ->
          window.data.push point.properties.velocity
      map.data.addGeoJson(json)
    error: (error) ->
      console.log error
  return json

addPoints = ->
  if !window.running
    return
  # fetch new points
  json = fetch()
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
    document.getElementById('latitude').textContent  = event.feature.getGeometry().get().lat().round(5)
    document.getElementById('longitude').textContent = event.feature.getGeometry().get().lng().round(5)
    document.getElementById('velocity').textContent  = event.feature.getProperty("velocity").round(2)
    document.getElementById('altitude').textContent  = event.feature.getProperty("altitide")
    document.getElementById('lap').textContent       = event.feature.getProperty("lap")
    return
  return


$('*').click ->
  window.running = !window.running
$ ->
  setInterval(addPoints, window.interval)

Array.prototype.last = ->
  return this[this.length-1]

Number.prototype.round = (places) ->
  return +(Math.round(this + "e+" + places)  + "e-" + places)
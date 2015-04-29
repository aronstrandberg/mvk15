"use strict"

# variables
running = true #lolololololololololololololololololololololololololololololololololololololololololol
lat = 59.347282
lng = 18.070712
id = 1
step = 1
n = 10
xstep = 0
ystep = 0
xdir = 1
ydir = 1
interval = 5000


map = undefined
mapStyle = [
  {
    'featureType': 'all'
    'elementType': 'all'
    'stylers': [
      {'invert_lightness': true}
      {'saturation': -100}
      {'lightness:': 15}
    ]
  }
]
mapOptions = {
  center: {
    lat: 59.346659
    lng: 18.072063
  }
  zoom: 16
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
      scale: 12
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

addPoints = ->
  if !running
    return
  # randomize blip color
  v = Math.random() * 11 + 1
  # randomize distance travelled
  xstep = Math.random() / 1000
  ystep = Math.random() / 1000

  # randomize new dirction every now and then
  if step % n == 0
    xdir = Math.random() * 2 - 1
    ydir = Math.random() * 2 - 1
    n = Math.floor Math.random() * 15 + 1
    # console.log n

  # make it travel!
  lat += xstep * xdir
  lng += ystep * ydir
  id++
  step++

  # add the blips
  json = """
          {
            "type": "FeatureCollection",
            "metadata": {},
            "features": [
              {
                "type": "Feature", "properties": {"velocity": #{v}},
                "geometry": {
                  "type": "Point",
                  "coordinates": [#{lng}, #{lat}]
                },
                "id": #{id}
              }
            ],
            "bbox": [-179.463, -60.7674, -2.9, 178.4321, 67.0311, 609.13]
          }
          """
  map.data.addGeoJson($.parseJSON(json))

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
    document.getElementById('info').textContent = event.feature.k.velocity
    return
  return


$('*').keypress ->
  running = !running
  return
$ setInterval(addPoints, interval)

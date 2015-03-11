var map;
var mapStyle = [{
  'featureType': 'all',
  'elementType': 'all',
  'stylers': [{'visibility': 'on'}]
}, {
  'featureType': 'landscape',
  'elementType': 'geometry',
  'stylers': [{'visibility': 'on'}, {'color': '#fcfcfc'}]
}, {
  'featureType': 'water',
  'elementType': 'labels',
  'stylers': [{'visibility': 'off'}]
}, {
  'featureType': 'all',
  'elementType': 'labels',
  'stylers': [{'visibility': 'off'}]
},
{
  'featureType': 'water',
  'elementType': 'geometry',
  'stylers': [{'visibility': 'on'}, {'hue': '#5f94ff'}, {'lightness': 60}]
}];

var mapOptions = {
    center: { lat: 59.346659, lng: 18.072063 },
    zoom: 15,
    styles: mapStyle,
    disableDefaultUI: true,
    mapMaker: true,
    minZoom: 10,
    //mapTypeId: google.maps.MapTypeId.TERRAIN
  };

// Defines the callback function referenced in the jsonp file.
function eqfeed_callback(data) {
  map.data.addGeoJson(data);
}

function styleFeature(feature) {
  var low = [151, 83, 34];   // color of mag 1.0
  var high = [5, 69, 54];  // color of mag 6.0 and above
  var minValue = 1.0;
  var maxValue = 12.0;

  // fraction represents where the value sits between the min and max
  var fraction = (Math.min(feature.getProperty('velocity'), maxValue) - minValue) / (maxValue - minValue);

  var color = interpolateHsl(low, high, fraction);

  return {
    icon: {
      path: google.maps.SymbolPath.CIRCLE,
      strokeWeight: 1.5,
      strokeColor: '#fff',
      fillColor: color,
      fillOpacity: 1,
      scale: 8
    },
    zIndex: Math.floor(feature.getProperty('velocity'))
  };
}

function interpolateHsl(lowHsl, highHsl, fraction) {
  var color = [];
  for (var i = 0; i < 3; i++) {
    // Calculate color based on the fraction.
    color[i] = (highHsl[i] - lowHsl[i]) * fraction + lowHsl[i];
  }
  return 'hsl(' + color[0] + ',' + color[1] + '%,' + color[2] + '%)';
}

google.maps.event.addDomListener(window, 'load', function() {
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  map.data.setStyle(styleFeature);

  // var script = document.createElement('script');
  // script.setAttribute('src', 'data.geo.json');
  // document.getElementsByTagName('head')[0].appendChild(script);
});

var lat = 59.347282;
var lng = 18.070712;
var id = 14;
var running = true;
var step = 1;
var xstep = 0;
var ystep = 0;
var xdir = Math.round(Math.random() * 2) - 1;
var ydir = Math.round(Math.random() * 2) - 1;

$("*").keypress(function() {
  running = !running;
});

function addPoints() {
  if (!running) { return; }

  // randomize blip color
  var v = Math.random() * 11 + 1;

  // randomize distance travelled
  xstep = Math.random()/1000;
  ystep = Math.random()/1000;

  // randomize new dirction every now and then
  if (step % 10 == 0) {
    xdir = Math.round(Math.random() * 2) - 1;
    ydir = Math.round(Math.random() * 2) - 1;
  }

  console.log(xdir);
  console.log(ydir);

  // make it travel!
  lat += xstep * xdir;
  lng += ystep * ydir;

  console.log(lat);
  console.log(lng);

  id++;
  step++;

  // add the blips
  var json = '{"type": "FeatureCollection", "metadata": {}, "features": [ {"type": "Feature", "properties": {"velocity":' + v + '}, "geometry": {"type": "Point", "coordinates": [' + lng +', ' + lat + ']}, "id": "' + id + '" } ], "bbox": [-179.463, -60.7674, -2.9, 178.4321, 67.0311, 609.13] }';
  var f = map.data.addGeoJson($.parseJSON(json));

  // pan to the new blip
  map.panTo({lat: lat, lng: lng});
}

$(setInterval(addPoints, 100));

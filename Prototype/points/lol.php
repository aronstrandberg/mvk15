<?php

function rand_float() {
  return mt_rand() / mt_getrandmax();
}

// If we haven't supplied an id, we probably want all of them.
$id = -1;
// If we supply an id we have got all points up till that id.
if(isset($_GET['id'])) {
  $id = intval($_GET['id']);
}

// Set up connection to database.
// 
$con = pg_connect("host=137.135.248.194 port=5432 dbname=mvk user=azureuser password=password")
  or die(http_response_code(418));

$result = pg_query($con, "SELECT * from location where id>".$id.";");
if (!$result) {
  exit;
}

$geoJson = '{ "type": "FeatureCollection",
  "features":[';

while ($row = pg_fetch_assoc($result)) {
  $geoJson .= '{
      "type": "Feature",
      "geometry": {"type": "Point", "Coordinates": [' . $row['longitude'] . ', ' . $row['latitude'] . ']},
      "properties": {"id": ' . $row['id'] . ', "timestamp": "' . $row['timestamp'] . '", "lap": ' . $row['lap'] . ', "velocity": '. (rand_float()*11+1) .'}
    },';
}

// Ignore last ',' since it's the last element in the "Feature" list.
$geoJson = substr($geoJson, 0, -1);
// Append the "bbox" attribute which is for some unknown reason needed for the gmaps API. 
$geoJson .= '
  ],
    "bbox": [-179.463, -60.7674, -2.9, 178.4321, 67.0311, 609.13]
 }';

echo $geoJson;

?>
<?php

// If we haven't supplied an id, we probably want all of them.
$id = -1;
// If we supply an id we have got all points up till that id.
if(isset($_GET['id'])) {
  $id = intval($_GET['id']);
}

$latest = -1;

// If we haven't supplied an lap, we probably want the latest.
$lap = $latest;
// If we supply an lap we have got all points up till that lap.
if(isset($_GET['lap'])) {
  $lap = intval($_GET['lap']);
}

// Set up connection to database.
// Otherwise return HTTP response code 418.
/// Might be a good idea to find a more secure way to connect to the database
/// set a better password.

$con = pg_connect("host=137.135.248.194 port=5432 dbname=mvk user=azureuser password=password")
  or die(http_response_code(418));

// Construct query.
$query = "select * from location where (id > $id and lap = ";
if ($lap == -1) {
  $query .= "(select max(lap) from location)";
} else {
  $query .= "$lap";
}
$query .= ");";

// Perform the SQL query!
$result = pg_query($con, $query);
if (!$result) {
  exit;
}

// The GeoJSON string to be constructed.
$geoJson = <<< HERE
{
  "type": "FeatureCollection",
  "features":[ 
HERE;

while ($row = pg_fetch_assoc($result)) {
  if ($row["timestamp"] == -1
   && $row["altitude"]  == -1
   && $row["speed"]     == -1) {
    http_response_code(203);
    break;
  }
  // Convert the SQL tuple into a JSON object.
  $geoJson .= <<< HERE
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          $row[longitude],
          $row[latitude]
        ]
      },
      "properties": {
        "timestamp": "$row[timestamp]",
        "lap": $row[lap],
        "altitude": $row[altitude],
        "velocity": $row[speed],
        "id":       $row[id]
      }
    },
HERE;
}

// Ignore last ',' since it's the last element in the "Feature" list.
$geoJson = substr($geoJson, 0, -1);

// Close the JSON string.
$geoJson .= '
  ]
}';

// Output the JSON for the ajax call.
echo $geoJson;

?>
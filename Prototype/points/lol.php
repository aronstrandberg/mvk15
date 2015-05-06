<?php

// If we haven't supplied an id, we probably want all of them.
$id = -1;
// If we supply an id we have got all points up till that id.
if(isset($_GET['id'])) {
  $id = intval($_GET['id']);
}

// Magic number for the latest number.
$latest = -1;

// If we haven't supplied an lap, we probably want the latest.
$lap = $latest;
// If we supply an lap we have got all points up till that lap.
if(isset($_GET['lap'])) {
  $lap = intval($_GET['lap']);
}

// Set up connection to database.
// Otherwise return HTTP response code 418.
$con = pg_connect("host=137.135.248.194 port=5432 dbname=mvk user=azureuser password=password")
  or die(http_response_code(418));

// Construct query.
$query = "select * from location where (id > $id and lap = ";
if ($lap == $latest) {
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

// Num of tuples from the database.
$num = pg_affected_rows($result);
// We haven't got any new tuples.
if ($num == 0) {
  // Special response code, saying there's no more content.
  http_response_code(204);
  exit;
}

// The GeoJSON string to be constructed.
$geoJson = <<< HERE
{
  "type": "FeatureCollection",
  "features":[ 
HERE;

// Convert tuples to GeoJSON.
while ($row = pg_fetch_assoc($result)) {
  // When we recieve a zeroed tuple, the drone has finished the lap.
  if ($row["timestamp"] == -1
   && $row["altitude"]  == -1
   && $row["speed"]     == -1) {
    http_response_code(205);
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
// A JSON thing...
$geoJson = substr($geoJson, 0, -1);

// Close the JSON string.
$geoJson .= '
  ]
}';

// Output the JSON for the ajax call.
echo $geoJson;

?>
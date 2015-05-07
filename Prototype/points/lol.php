<?php

// get_id and get_lap.
require 'functions.php';

// Set up connection to database.
// Otherwise return HTTP response code 418.
try {
  $db = new PDO(
    'pgsql:dbname=mvk host=137.135.248.194 port=5432',
    "azureuser",
    "password"
  );
  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
  echo 'Connection failed: ' . $e->getMessage();
  die(http_response_code(418));
}

// If we haven't supplied an id, we probably want all of them.
$id = -1;

// Magic number for the latest lap.
$latest = -1;
// If we haven't supplied an lap, we probably want the latest.
$lap = $latest;

// Update id and lap if we got a query.
get_id();
get_lap();

// Get the latest lap if we haven't specified a lap.
if ($lap == $latest) {
  $query = "select max(lap) from location;";
  $max = $db->query($query)->fetch()["max"];
  $lap = $max;
}

// Construct query.
$query = "select * from location where (id > :id and lap = :lap);";

// Prepare query.
$stmt = $db->prepare($query);
$stmt->execute(array(':id' => $id, ':lap' => $lap));

// Fetch all results.
$res = $stmt->fetchAll();

// Num of tuples from the database.
$num = count($res);

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
foreach($res as $tuple) {
  // When we recieve a zeroed tuple, the drone has finished the lap.
  if ($tuple["timestamp"] == -1
   && $tuple["altitude"]  == -1
   && $tuple["speed"]     == -1) {
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
          $tuple[longitude],
          $tuple[latitude]
        ]
      },
      "properties": {
        "timestamp": "$tuple[timestamp]",
        "lap":        $tuple[lap],
        "altitude":   $tuple[altitude],
        "velocity":   $tuple[speed],
        "id":         $tuple[id]
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

<?php

$latest = -1;

// Get lap receives a query from the frontend to change the lap.
function get_id() {
  // If we haven't supplied an id, we probably want all of them.
  $id = -1;

  // If we supply an id we have got all points up till that id.
  if(isset($_GET['id'])) {
    $id = intval($_GET['id']);
  }
  return $id;
}

// Get lap receives a query from the frontend to change the lap.
function get_lap() {
  global $latest;

  // Magic number for the latest lap.
  // If we haven't supplied an lap, we probably want the latest.
  $lap = $latest;

  // If we supply an lap we have got all points up till that lap.
  if(isset($_GET['lap'])) {
    $lap = intval($_GET['lap']);
  }
  return $lap;
}

// connect to the database and return a PDO object for queries.
function connect() {
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
  return $db;
}

// get_tuples takes a database connection, a lap id and a point id to make a
// database query to retrieve tuples.
function get_tuples($db, $lap, $point_id) {
  global $latest;

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
  $stmt->execute(array(':id' => $point_id, ':lap' => $lap));

  // Fetch all results.
  return $stmt->fetchAll();
}

// geo_json takes an array of tuples and converts it into a GeoJSON string.
function geo_json($tuples) {
  // The GeoJSON string to be constructed.
  $geoJson = <<< HERE
  {
    "type": "FeatureCollection",
    "features":[ 
HERE;

  // Convert tuples to GeoJSON.
  foreach($tuples as $tuple) {
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

  return $geoJson;
}

?>

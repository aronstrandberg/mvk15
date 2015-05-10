<?php

// get_id and get_lap.
require 'functions.php';

// Connect to the database.
$db = connect();

// Update id and lap if we got a query.
$id = get_id();
$lap = get_lap();

// Get tuples for the specific lap.
$tuples = get_tuples($db, $lap, $id);

// We haven't got any new tuples.
if (count($tuples) == 0) {
  // Special response code, saying there's no more content.
  http_response_code(204);
  exit;
}

// Output the JSON for the ajax call.
echo geo_json($tuples);

?>

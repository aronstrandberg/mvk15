<?php

function rand_float() {
  return mt_rand() / mt_getrandmax();
}
function random($min, $max) {
  return $min + rand_float() * $max;
}
$random = "random";
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

$geoJson = <<<HEREDOC
{
  "type": "FeatureCollection",
  "metadata": {},
  "features": [

HEREDOC;

while ($row = pg_fetch_assoc($result)) {
$geoJson .= <<<HEREDOC
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [{$row["longitude"]}, {$row["latitude"]}]
      },
      "properties": {
        "timestamp": "{$row["timestamp"]}",
        "lap": {$row["lap"]},
        "velocity": {$random(1, 11)}
      },
      "id": {$row["id"]}
    },

HEREDOC;
}
// Ignore last ',' since it's the last element in the "Feature" list.
$geoJson = rtrim($geoJson);
$geoJson = substr($geoJson, 0, -1);

$geoJson .= '
  ]
}';

echo $geoJson;

?>
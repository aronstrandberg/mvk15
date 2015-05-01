<?php
 // set up connection to database
$dbcon = pg_connect("host=137.135.248.194 port=5432 dbname=mvk user=azureuser")
	or die("Unable to connect to database<br>");

// confirm that the database has been connected to
echo "Connected to database <br>";

// create infinite loop, second basis 
while (1) {
 // gather the new and unread data, update read to 1, and return the updated information
  $newData = pg_fetch_all(
    pg_query($dbcon, "UPDATE location SET read = 1 WHERE read = 0 RETURNING *") 
  );

 // convert all gathered data to geoJSON for website function, push
  foreach ($newData as $lineData) {
// create a GeoJSON-formatted string
// heredoc fucks up if it's indented    
$json = <<<EOT
  {
    "type": "FeatureCollection",
    "metadata": {},
    "features": [
      {
        "type": "Feature",
        "properties": {
          "velocity": {$line["v"]},
          "timestamp": {$line["ts"]},
          "lap": {$line["lap"]}
        },
        "geometry": {
          "type": "Point",
          "coordinates": [{$line["lng"]}, {$line["lat"]}]
        },
        "id": {$line["id"]}
      }
    ],
    "bbox": [-179.463, -60.7674, -2.9, 178.4321, 67.0311, 609.13]
  }
EOT;
    }

    // wait one second for next database data gathering
    sleep(1);
}
 ?>

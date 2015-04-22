<?php

	// set database login details
	 $connection_string = "dono";   // database name, passowrd, bla bla
	 $connect_type = "dono";

	 // set up connection to database
	 $dbcon = resource pg_connect(string $connection_string [, int $connect_type])
	 	or die("Unable to connect to database<br>");
	 echo "Connected to database <br>";
	
	 // create infinite loop, second basis 
	 while (1){	
		 	
		 // gather the new and unread data, update and read same time
		 $newData = pg_fetch_all (
		 					pg_query (UPDATE tabellen SET read = 1 WHERE read = 0
		 					RETURNING *)
		 					);

		 // convert all gathered data to geoJSON for website function, push
		 for ($lineData in $newData) {
		 	
		 	// TODO : convert to geoJson 
		 	$geoJson = { "type": "FeatureCollection",

		 				"features":[

		 					{
		 						"type": "Feature",
		 						"geometry": {"type": "Point", "Coordinates": [$lineData[long], $lineData[lat]]},
		 						"properties": {"ID": $lineData[ID], "timestamp": $lineData[ts], "lap": $lineData[lap]}

		 					}
		 				]
		 			}

		 	// TODO : push to website 
		 	

		 }

		 // wait one second
		 sleep(1);
	}

 ?>

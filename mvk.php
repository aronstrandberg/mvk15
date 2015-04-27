<?php

	 // set up connection to database, if not successfull "output unable to connect"
	 $dbcon = pg_connect("host=137.135.248.194 port=5432 dbname=mvk user=azureuser")
	 	or die("Unable to connect to database<br>");
	 

	 // confirm that the database has been connected to
	 echo "Connected to database <br>";
	
	 // create infinite loop, second basis 
	 while (1){	
		 	
		 // gather the new and unread data, update read to 1, and return the updated information
		 $newData = pg_fetch_all (
		 					pg_query (UPDATE location SET read = 1 WHERE read = 0
		 					RETURNING *)
		 					);

		 // convert all gathered data to geoJSON for website function, push
		 for ($lineData in $newData) {
		 	
		 	// TODO : convert to geoJson format
		 	$geoJson = { "type": "FeatureCollection",

		 				"features":[

		 					{
		 						"type": "Feature",
		 						"geometry": {"type": "Point", "Coordinates": [$lineData[long], $lineData[lat]]},
		 						"properties": {"ID": $lineData[ID], "timestamp": $lineData[ts], "lap": $lineData[lap]}
		 					}
		 				]
		 			}

		 	// make output geoJson, which will be gathered by website continously for data flow
		 	echo $geoJson

		 }

		 // wait one second for next database data gathering
		 sleep(1);
	}

 ?>

 ?>

function velocity(query1, query2) {
	var t = query1.time - query2.time

	var d = distance(query1.lat, query2.lat, query1.lon, query2.lon)

	return d/t
}

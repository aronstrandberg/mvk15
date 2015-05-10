-- Table for keeping track of the laps
CREATE TABLE laps(
	id SERIAL PRIMARY KEY,
	droneid INTEGER,
)

-- Table for keeping track of the GPS points
CREATE TABLE Location(
	id SERIAL PRIMARY KEY,
	timestamp TEXT,
	longitude FLOAT,
	latitude FLOAT,
	speed FLOAT,
	altitude FLOAT,
	lap INTEGER
);

-- Sample data
INSERT INTO Location(timestamp, longitude, latitude, speed, altitude, lap) VALUES ('03-05-2015', 18.07354, 59.34733, 12.123, 1.1234, 1);
INSERT INTO Location(timestamp, longitude, latitude, speed, altitude, lap) VALUES ('03-05-2015', 18.07292, 59.34714, 12.123, 1.1234, 1);
INSERT INTO Location(timestamp, longitude, latitude, speed, altitude, lap) VALUES ('03-05-2015', 18.07300, 59.34699, 12.123, 1.1234, 1);
INSERT INTO Location(timestamp, longitude, latitude, speed, altitude, lap) VALUES ('03-05-2015', 18.07341, 59.34702, 12.123, 1.1234, 1);
INSERT INTO Location(timestamp, longitude, latitude, speed, altitude, lap) VALUES ('03-05-2015', 18.07358, 59.34711, 12.123, 1.1234, 1);

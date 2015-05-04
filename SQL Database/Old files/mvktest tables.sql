CREATE TABLE drone_Model (
id INTEGER PRIMARY KEY, 
model VARCHAR(30), 
max_weight FLOAT);

CREATE TABLE drone (
id INTEGER PRIMARY KEY, 
model_id INTEGER REFERENCES drone_Model (id));

CREATE TABLE drone_Data (
id INTEGER PRIMARY KEY, 
drone_id INTEGER REFERENCES drone (id), 
location_id INTEGER NOT NULL UNIQUE,
timestamp TIMESTAMP);

CREATE TABLE location (
id INTEGER PRIMARY KEY REFERENCES drone_Data (location_id),
gps POINT);




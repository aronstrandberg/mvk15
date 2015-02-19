-- Drone_Model (id, model, max_weight)
INSERT INTO drone_Model VALUES (1 , 'AR.Drone 2.0 Standard Edition', 500);
INSERT INTO drone_Model VALUES (2 , 'AR.Drone 2.0 Power Edition', 600);
INSERT INTO drone_Model VALUES (3 , 'AR.Drone 2.0 Elite Edition', 700);
INSERT INTO drone_Model VALUES (4 , 'AR.Drone 3.0 Martin Deluxe', 500);
INSERT INTO drone_Model VALUES (5 , 'AR.Drone 4.0 Rally Exclusive', 600);
INSERT INTO drone_Model VALUES (6 , 'AR.Drone 2000 SWAG Edition', 700);

-- Drone (id, model_id)
INSERT INTO drone VALUES (101, 1);
INSERT INTO drone VALUES (102, 2);
INSERT INTO drone VALUES (103, 3);
INSERT INTO drone VALUES (104, 4);
INSERT INTO drone VALUES (105, 5);
INSERT INTO drone VALUES (106, 6);

-- Drone_Data (id, drone_id, location_id, timestamp)
INSERT INTO drone_Data VALUES (201, 101, 301, '2015-02-09 19:36:23');
INSERT INTO drone_Data VALUES (202, 102, 302, '2015-02-09 19:36:35');
INSERT INTO drone_Data VALUES (203, 103, 303, '2015-02-09 19:36:21');
INSERT INTO drone_Data VALUES (204, 104, 304, '2015-02-09 19:36:42');
INSERT INTO drone_Data VALUES (205, 105, 305, '2015-02-09 19:36:24');
INSERT INTO drone_Data VALUES (206, 106, 306, '2015-02-09 19:36:43');
INSERT INTO drone_Data VALUES (207, 101, 307, '2015-02-08 19:36:23');
INSERT INTO drone_Data VALUES (208, 102, 308, '2015-02-08 19:36:35');
INSERT INTO drone_Data VALUES (209, 103, 309, '2015-02-08 19:36:21');
INSERT INTO drone_Data VALUES (210, 104, 310, '2015-02-08 19:36:42');
INSERT INTO drone_Data VALUES (211, 105, 311, '2015-02-08 19:36:24');
INSERT INTO drone_Data VALUES (212, 106, 312, '2015-02-08 19:36:43');
INSERT INTO drone_Data VALUES (213, 101, 313, '2015-02-07 19:36:23');
INSERT INTO drone_Data VALUES (214, 102, 314, '2015-02-07 19:36:35');
INSERT INTO drone_Data VALUES (215, 103, 315, '2015-02-07 19:36:21');
INSERT INTO drone_Data VALUES (216, 104, 316, '2015-02-07 19:36:42');
INSERT INTO drone_Data VALUES (217, 105, 317, '2015-02-07 19:36:24');
INSERT INTO drone_Data VALUES (218, 106, 318, '2015-02-07 19:36:43');

-- Location(id, gps)
INSERT INTO Location VALUES (301, point(0,1));
INSERT INTO Location VALUES (302, point(0,2));
INSERT INTO Location VALUES (303, point(0,3));
INSERT INTO Location VALUES (304, point(0,4));
INSERT INTO Location VALUES (305, point(1,1));
INSERT INTO Location VALUES (306, point(1,2));
INSERT INTO Location VALUES (307, point(1,3));
INSERT INTO Location VALUES (308, point(1,4));
INSERT INTO Location VALUES (309, point(2,1));
INSERT INTO Location VALUES (310, point(2,2));
INSERT INTO Location VALUES (311, point(2,3));
INSERT INTO Location VALUES (312, point(2,4));
INSERT INTO Location VALUES (313, point(3,1));
INSERT INTO Location VALUES (314, point(3,2));
INSERT INTO Location VALUES (315, point(3,3));
INSERT INTO Location VALUES (316, point(3,4));
INSERT INTO Location VALUES (317, point(4,1));
INSERT INTO Location VALUES (318, point(4,2));
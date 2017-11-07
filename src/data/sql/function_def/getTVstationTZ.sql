DROP FUNCTION IF EXISTS getTVstationTZ;
DELIMITER //
CREATE FUNCTION getTVstationTZ (tv_station_id INT) RETURNS VARCHAR(24)
BEGIN
	DECLARE tz VARCHAR(24);

	#"lineup":{"country":"USA","postal_code":"94710","lineup_id":"USA-OTA94710","lineup_name":"Local Over the Air Broadcast","tz":"US/Pacific"}
	IF (tv_station_id IN ("19574", "19572", "19571", "21785", "19575", "42617", "67470", "84446")) THEN
        SET tz = 'US/Pacific';
	# Rest are cable/broadcast networks. Safe to assume EST for those
	ELSE SET tz = 'US/Eastern';
    END IF;

    RETURN(tz);
END//
DELIMITER ;
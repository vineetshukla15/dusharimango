DROP FUNCTION IF EXISTS getTZString;
DELIMITER //
CREATE FUNCTION getTZString (strinput VARCHAR(10)) RETURNS VARCHAR(10)
BEGIN
	DECLARE rtnval VARCHAR(10);
    
	CASE strinput
		WHEN '540' THEN SET rtnval = '+09:00';
		WHEN '600' THEN SET rtnval = '+10:00';
		WHEN '-240' THEN SET rtnval = '-04:00';
		WHEN '-300' THEN SET rtnval = '-05:00';
		WHEN '-360' THEN SET rtnval = '-06:00';
		WHEN '-420' THEN SET rtnval = '-07:00';
		WHEN '-480' THEN SET rtnval = '-08:00';
		WHEN '-540' THEN SET rtnval = '-09:00';
		WHEN '-600' THEN SET rtnval = '-10:00';
		WHEN '-660' THEN SET rtnval = '-11:00';
		ELSE SET rtnval = '+00:00';
	END CASE;
    
    RETURN(rtnval);
END//
DELIMITER ;
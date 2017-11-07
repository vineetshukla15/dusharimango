DROP FUNCTION IF EXISTS getBroadcastYear;
DELIMITER //
CREATE FUNCTION getBroadcastYear (airing_time DATETIME) RETURNS INT(4)
BEGIN
	DECLARE byear INT(4);
    DECLARE airing_date DATE;
    
    SET airing_date = DATE(airing_time);

    SET byear = YEAR(ADDDATE(airing_date, (6 - WEEKDAY(airing_date))));

    RETURN(byear);
END//
DELIMITER ;

DROP FUNCTION IF EXISTS getBroadcastQuarter;
DELIMITER //
CREATE FUNCTION getBroadcastQuarter (airing_time DATETIME) RETURNS VARCHAR(2)
BEGIN
	DECLARE bq VARCHAR(2);
    DECLARE airing_date DATE;
    
    SET airing_date = DATE(airing_time);

    SET bq = CONCAT('Q', QUARTER(ADDDATE(airing_date, (6 - WEEKDAY(airing_date)))));

    RETURN(bq);
END//
DELIMITER ;

DROP FUNCTION IF EXISTS getBroadcastMonth;
DELIMITER //
CREATE FUNCTION getBroadcastMonth (airing_time DATETIME) RETURNS VARCHAR(20)
BEGIN
	DECLARE bmonth VARCHAR(20);
    DECLARE airing_date DATE;
    
    SET airing_date = DATE(airing_time);

    SET bmonth = SUBSTR(MONTHNAME(ADDDATE(airing_date, (6 - WEEKDAY(airing_date)))), 1, 3);

    RETURN(bmonth);
END//
DELIMITER ;

DROP FUNCTION IF EXISTS getBroadCastWeek;
DELIMITER //
CREATE FUNCTION getBroadcastWeek (airing_time DATETIME) RETURNS INT(2)
BEGIN
	DECLARE bweek INT(2);
    DECLARE airing_date DATE;
    
    SET airing_date = DATE(airing_time);

    SET bweek = WEEK(ADDDATE(airing_date, (6 - WEEKDAY(airing_date))), 2);

    RETURN(bweek);
END//
DELIMITER ;
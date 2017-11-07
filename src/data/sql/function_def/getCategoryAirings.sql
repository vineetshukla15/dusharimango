DROP FUNCTION IF EXISTS getCategoryAirings;
DELIMITER //
CREATE FUNCTION getCategoryAirings (cat_id INT, startDate Date, endDate Date, useTempTbl Boolean) RETURNS INT(11)
BEGIN
	DECLARE cat_airings INT(11);
    SET cat_airings = 0;
    
    IF (cat_id = 0 OR cat_id IS NULL) THEN
		IF (useTempTbl) THEN
			SELECT sum(airings) INTO cat_airings FROM category_airings_temp WHERE category_id IS NULL AND airing_date BETWEEN startDate AND endDate;
        ELSE
			SELECT sum(airings) INTO cat_airings FROM category_airings WHERE category_id IS NULL AND airing_date BETWEEN startDate AND endDate;
        END IF;
    ELSE
		IF (useTempTbl) THEN
			SELECT sum(airings) INTO cat_airings FROM category_airings_temp WHERE category_id = cat_id AND airing_date BETWEEN startDate AND endDate;
        ELSE
			SELECT sum(airings) INTO cat_airings FROM category_airings WHERE category_id = cat_id AND airing_date BETWEEN startDate AND endDate;
        END IF;
    END IF;
	
    RETURN(cat_airings);
END//
DELIMITER ;
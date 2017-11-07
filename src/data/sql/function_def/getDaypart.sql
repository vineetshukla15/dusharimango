DROP FUNCTION IF EXISTS getDaypart;
DELIMITER //
CREATE FUNCTION getDaypart (datetimeLocal DATETIME, ignoreWeekend BOOLEAN) RETURNS VARCHAR(24)
BEGIN
    DECLARE daypart VARCHAR(24);
    DECLARE dayofweek INT(1);
    DECLARE hourofday INT(2);
    
    SET dayofweek = WEEKDAY(datetimeLocal);
    SET hourofday = HOUR(datetimeLocal);

    IF (dayofweek <= 4 OR ignoreWeekend) THEN # That is Day is between Monday to Friday
        IF (hourofday < 1) THEN SET daypart = 'LATE FRINGE';
        ELSEIF (hourofday < 5) THEN SET daypart = 'OVER NIGHT';
        ELSEIF (hourofday < 10) THEN SET daypart = 'EARLY MORNING';
        ELSEIF (hourofday < 16) THEN SET daypart = 'DAY TIME';
        ELSEIF (hourofday < 19) THEN SET daypart = 'EARLY FRINGE';
        ELSEIF (hourofday < 23) THEN SET daypart = 'PRIME TIME';
        ELSE SET daypart = 'LATE FRINGE';
        END IF;
    ELSE # That is Day is Saturday / Sunday
        IF (hourofday < 13) THEN SET daypart = 'WEEKEND DAY';
        ELSEIF (hourofday < 19) THEN SET daypart = 'WEEKEND AFTERNOON';
        ELSEIF (hourofday < 23) THEN SET daypart = 'PRIME TIME';
        ELSE SET daypart = 'WEEKEND DAY';
        END IF;
    END IF;

    RETURN(daypart);
END//
DELIMITER ;
DROP FUNCTION IF EXISTS checkLARDraftOrNew;
DELIMITER //
CREATE FUNCTION checkLARDraftOrNew (user_id TEXT) RETURNS VARCHAR(10)
BEGIN
	DECLARE state VARCHAR(10);
    DECLARE rptsUnderProcess INT(1);
    SET state = 'new';
    
    IF (user_id = '' OR user_id IS NULL) THEN
		SELECT count(*) INTO rptsUnderProcess FROM queue_location_attrib_query WHERE created_by IS NULL AND (`status` = 'new' OR `status` = 'pending');
    ELSE
		SELECT count(*) INTO rptsUnderProcess FROM queue_location_attrib_query WHERE created_by = user_id AND (`status` = 'new' OR `status` = 'pending');
    END IF;
	
    IF (rptsUnderProcess >= 5) THEN SET state = 'draft'; END IF;
    
    RETURN(state);
END//
DELIMITER ;
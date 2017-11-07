DROP FUNCTION IF EXISTS isStasticallySignificant;
DELIMITER //
CREATE FUNCTION isStasticallySignificant (report_id INT) RETURNS BOOLEAN
BEGIN
	DECLARE isSignificant BOOLEAN;
    DECLARE thresholdSize INT;
    DECLARE sampleExposed INT;
    DECLARE sampleUnExposed INT;
    DECLARE visitExposed INT;
    DECLARE visitUnExposed INT;
    DECLARE liftVal FLOAT;
    
    SET isSignificant = FALSE;
    SET thresholdSize = 5;
    
    
    SELECT sample_size_exposed, sample_size_unexposed, num_visited_exposed, num_visited_unexposed, lift
      INTO sampleExposed, sampleUnExposed, visitExposed, visitUnExposed, liftVal
    FROM results_of_location_attrib_query WHERE queue_id = report_id;
    
    IF (sampleExposed > thresholdSize AND sampleUnExposed > thresholdSize AND 
        visitEXPOSED > thresholdSize AND visitUnExposed > thresholdSize AND liftVal > 0)
	THEN
		SET isSignificant = TRUE;
    END IF;
    
    RETURN(isSignificant);
END//
DELIMITER ;
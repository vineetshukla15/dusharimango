DROP FUNCTION IF EXISTS getStarcomDaypart;
DELIMITER //
CREATE FUNCTION getStarcomDaypart (datetimeLocal DATETIME, network VARCHAR(100), show_tmsid varchar(100), show_genres VARCHAR(100)) RETURNS VARCHAR(24)
BEGIN
    DECLARE daypart VARCHAR(24);
    DECLARE dayofweek INT(1);
    DECLARE hourofday INT(2);
    
    SET dayofweek = WEEKDAY(datetimeLocal);
    SET hourofday = HOUR(datetimeLocal);

	IF (network IN ('NBC Universo', 'Telemundo', 'Univision', 'ESPN Deportes', 'Unimas')) THEN # Hispanic broadcast network
		SET daypart = 'Hispanic';
    ELSEIF (show_genres LIKE "%sport%" OR
		network IN ('ESPN', 'ESPN2', 'ESPN 2', 'ESPN Classic', 'ESPN U', 'Golf Channel', 'MLB Network', 'NBCSN', 'Tennis',
                    'CBS Sports', 'Sportsman', 'NBC Sports Network', 'NBATV') OR
        show_tmsid in ('NBA Basketball', 'NBA Countdown', 'Inside the NBA', 'March Madness', 'Figure Skating',
                       'Snowboarding', 'Daytona 500', 'UFC Fight Night', 'MLB Baseball', '2017 BBVA Compass Rising Stars Challenge',
                       '2017 Daytona 500', '2017 NBA All-Star Game', '2017 NBA All-Star Saturday', 'Bellator Kickboxing',
                       'Bellator MMA Live', 'College Basketball', 'NBA Talent Challenge', 'NBA Tip-Off', 'NFL Football',
                       'PGA Tour Golf', 'Sports Stars of Tomorrow', 'UFC Fight Night%', 'UFC Post Fight Show', 'UFC\'s Road to the Octagon%',
                       '30 for 30', 'FOX NFL Postgame', 'Area 21: NBA All-Star Edition', '2017 French Open Tennis') OR
        show_tmsid like 'UFC Fight Night%' OR show_tmsid like 'UFC\'s Road to the Octagon%') THEN
        SET daypart = 'Sports';
    # TODO: Put special shows
	ELSEIF (network IN ('ABC', 'CBS', 'NBC', 'FOX', 'CW')) THEN # Broadcast
		IF (((dayofweek <= 5 AND hourofday >= 20) OR (dayofweek = 6 AND hourofday >= 19)) AND hourofday < 23) THEN
			SET daypart = 'Prime';
        ELSEIF (hourofday >= 23 OR hourofday < 1) THEN
            SET daypart = 'Late Night';
		END IF;

        IF (network IN ('ABC', 'CBS', 'NBC')) THEN
			IF (show_tmsid in ('Jimmy Kimmel Live',
							   'Nightline',
                               'The Late Show With Stephen Colbert',
                               'The Late Late Show With James Corden',
                               'The Tonight Show Starring Jimmy Fallon',
                               'Late Night With Seth Meyers',
                               'Last Call With Carson Daly',
                               'Saturday Night Live')) THEN
				SET daypart = 'Late Night';
			ELSEIF (show_tmsid in ('Good Morning America',
								   'Live! With Kelly and Michael',
                                   'Today\'s Take')) THEN
				SET daypart = 'Early Morning';
			END IF;
		END IF;
    ELSE # Cable
        SET daypart = 'Cable';
    END IF;

    # Override
    IF ((network = 'USA' AND show_tmsid in ('Team Ninja Warrior')) OR
        (network = 'MTV2' AND show_tmsid in ('Rob Dyrdek\'s Fantasy Factory')))THEN
        SET daypart = 'Cable';
	END IF;
    IF (show_tmsid in ('Dick Clark\'s Primetime New Year\'s Rockin\' Eve With Ryan Seacrest 2016', 'Dick Clark\'s New Year\'s Rockin\' Eve With Ryan Seacrest 2016',
                       'Dick Clark\'s Primetime New Year\'s Rockin\' Eve With Ryan Seacrest 2017', 'Dick Clark\'s New Year\'s Rockin\' Eve With Ryan Seacrest 2017',
                       '68th Primetime Emmy Awards', 'Countdown to the Emmy Awards: Red Carpet Live', 'On The Red Carpet at the Emmys',
                       'On the Red Carpet at the Oscars', 'Oscars Opening Ceremony: Live From the Red Carpet', 'The Oscars',
                       '2016 Billboard Music Awards', '2017 Billboard Music Awards', '2016 American Music Awards',
                       'Grammy Red Carpet Live', 'Grammy Special', 'The 58th Annual Grammy Awards', 'The 59th Annual Grammy Awards',
                       '51st Academy of Country Music Awards', '52nd Academy of Country Music Awards'
                       '2016 Golden Globe Arrivals Special', 'The 73rd Annual Golden Globe Awards', '2017 Golden Globe Arrivals Special', 'The 74th Annual Golden Globe Awards'
                       '2016 MTV Video Music Awards', '2017 MTV Movie & TV Awards', 'The 71st Annual Tony Awards')) THEN
        SET daypart = 'Specials';
	END IF;
    IF (network = 'ABC' AND show_tmsid = 'The Ten Commandments' AND 
        (((dayofweek <= 5 AND hourofday >= 20) OR (dayofweek = 6 AND hourofday >= 19)) AND hourofday < 24)) THEN
        SET daypart = 'Prime';
	END IF;
    IF (network = 'FOX' AND show_tmsid = '24: Legacy' AND DATE(datetimeLocal) = '2017-02-05') THEN
        SET daypart = 'Prime';
	END IF;
    
    RETURN(daypart);
END//
DELIMITER ;
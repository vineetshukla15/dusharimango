SELECT * FROM insights.content_airings_master;

drop function if exists insights.getTvStationTZ;
delimiter //
create function insights.getTvStationTZ (tv_station_id INT) returns varchar(24)
begin
	declare tz varchar(24);

    IF (tv_station_id in ("76126", "16365", "10183", "26077", "26078", "26079", "14929", "10222",
						  "46817", "32281", "58570", "70387", "15807", "52199", "26028", "26028",
                          "47540", "33395", "11180", "59036",
                          "20453", "16689", "20373", "20360", "20459", "82183", "54437", "35361",
                          "19596", "20431", "20362", "20358")) THEN #,"10146")) THEN // Duplicate value in the config file
        set tz = 'US/Eastern';
	ELSEIF (tv_station_id in ("19574", "19572", "19571", "21785", "19575", "42617", "67470", "84446")) THEN
        set tz = 'US/Pacific';
	ELSEIF (tv_station_id in ("51529", "59337", "18284", "57394", "18332", "63236", "61135", "14755",
							  "21883", "58625", "60048", "14897", "55205", "48969", "59440", "58780",
                              "58646", "62420", "30156", "10138", "10161", "10162", "16617", "16618",
                              "16125", "11150", "59684", "74796", "18279", "18544", "10989", "36225",
                              "45507", "15451", "25595", "32645", "59976", "60696", "18511", "50747",
                              "58718", "60179", "82541", "59305", "59615", "83173", "58574", "66379",
                              "58988", "14899", "66268", "46710", "64549", "49788", "57708", "10269",
                              "65342", "14873", "60150", "55887", "16300", "60964", "30418", "18715",
                              "16361", "44228", "49438", "67331", "48639", "45399", "65025", "19211",
                              "59432", "30420", "46737", "25622", "21484", "11069", "63717", "57390",
                              "89714", "59186", "33930", "16108", "58623", "58515", "12852", "58812",
                              "57391", "35329", "42642", "64490", "73541", "34763", "58452", "31046",
                              "60046", "22561", "91096", "59296", "19051", "14791", "65732",
                              "28506", "61469", "60468", "50057", "16062", "68827", "62079", "49141", "44905"
                              "26849",
                              "16484", "10146", "46762", "30419")) THEN
        set tz = 'US/Central';
	ELSE set tz = 'US/Eastern';
    END IF;

    return(tz);
end//
delimiter ;

REPLACE INTO insights.content_airings_master
select content_id, airing_time as airing_start_time_UTC,
	   (CASE WHEN(seq_no < 0)THEN 0 ELSE seq_no END) as pod_position,
       ad_cost_est as spend, stations_id as tv_station_id,
       insights.getTvStationTZ(stations_id) as tv_station_tz, network as tv_network,
       show_name as show_title, show_genre as show_genres,
       '0000-00-00 00:00:00' as show_start_time_UTC,
       '0000-00-00 00:00:00' as show_end_time_UTC
FROM tv_airings.ad_airings_all
where airing_time >= DATE_SUB(CURDATE(),INTERVAL 5 DAY);
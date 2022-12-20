TRUNCATE berrypeople,
    eventrating,
    house,
    overallrating,
    rights,
    settlement,
    trip,
    tripreltype,
    tripschedule,
    tripsorganizer,
    tripsparticipants,
    triptype;

DROP SEQUENCE
	berrypeople_id_seq,
	house_id_seq,
	rights_id_seq,
	trip_id_seq,
	triptype_id_seq;

ALTER SEQUENCE berrypeople_id_seq RESTART WITH 1;
UPDATE berrypeople SET id=nextval('berrypeople_id_seq');

ALTER SEQUENCE house_id_seq RESTART WITH 1;
UPDATE house_id_seq SET id=nextval('house_id_seq');

ALTER SEQUENCE rights_id_seq RESTART WITH 1;
UPDATE rights_id_seq SET id=nextval('rights_id_seq');

ALTER SEQUENCE trip_id_seq RESTART WITH 1;
UPDATE trip_id_seq SET id=nextval('trip_id_seq');

ALTER SEQUENCE triptype_id_seq RESTART WITH 1;
UPDATE triptype_id_seq SET id=nextval('triptype_id_seq');
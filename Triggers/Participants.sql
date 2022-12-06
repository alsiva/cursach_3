CREATE OR REPLACE FUNCTION add_participant()
    returns trigger
    language plpgsql
as
$$
begin
    if (select right_id from berrypeople where id = new.person_id) = 2 then
        raise EXCEPTION 'Извини, но ты в бане';
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_add_participant ON tripsparticipants;
CREATE TRIGGER tr_add_participant
    BEFORE INSERT or UPDATE
    ON tripsparticipants
    FOR EACH ROW
EXECUTE PROCEDURE add_participant();

CREATE OR REPLACE FUNCTION add_settlement()
    returns trigger
    language plpgsql
as
$$
declare
    house_size int;
begin
    select maxpeople into house_size from house where house_id = new.house_id;
    if (house_size = (select count(*)
                      from settlement
                      where house_id = new.house_id
                        and trip_id = new.trip_id)) then
        raise EXCEPTION 'Места в доме закончились';
    end if;
end;
$$;

DROP TRIGGER IF EXISTS tr_add_settlement ON settlement;
CREATE TRIGGER tr_add_participant
    BEFORE INSERT
    ON settlement
    FOR EACH ROW
EXECUTE PROCEDURE add_settlement();
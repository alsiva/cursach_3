CREATE OR REPLACE FUNCTION insupd_overall_rating()
    returns trigger
    language plpgsql
as
$$
declare
    new_rating_sum   int;
    new_rating_count int;
begin
    if (tg_op = 'INSERT' or tg_op = 'UPDATE') then
        select sum(rating) into new_rating_sum from eventrating where person_id = new.person_id;
        select count(rating) into new_rating_count from eventrating where person_id = new.person_id;

        if (select(exists(select 1 from overallrating where overallrating.person_id = new.person_id))) then
            update overallrating
            set rating = new_rating_sum / new_rating_count
            where person_id = new.person_id;
        else
            insert into overallrating(person_id, rating)
            values (new.person_id, new_rating_sum);
        end if;
    else
        select sum(rating) into new_rating_sum from eventrating where person_id = old.person_id;
        select count(rating) into new_rating_count from eventrating where person_id = old.person_id;

        if (select(exists(select 1 from overallrating where overallrating.person_id = old.person_id))) then
            update overallrating
            set rating = new_rating_sum / new_rating_count
            where person_id = old.person_id;
        else
            delete from overallrating where person_id = old.person_id;
        end if;
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_insupd_overall_rating ON eventrating;
CREATE TRIGGER tr_insupd_overall_rating
    AFTER INSERT or UPDATE or DELETE
    ON eventrating
    FOR EACH ROW
EXECUTE PROCEDURE insupd_overall_rating();



CREATE OR REPLACE FUNCTION house_capacity()
    returns trigger
    language plpgsql
as
$$
declare
    people_count   int;
    house_capacity int;
begin
    select maxpeople into house_capacity from house where new.house_id = house.id;

    select count(*)
    into people_count
    from settlement
    where new.house_id = settlement.house_id
      and new.trip_id = settlement.trip_id;


    if (house_capacity <= people_count and tg_op = 'INSERT') then
        raise exception 'Все места в доме заняты';
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_house_capacity ON settlement;
CREATE TRIGGER tr_house_capacity
    BEFORE INSERT
    ON settlement
    FOR EACH ROW
EXECUTE PROCEDURE house_capacity();



CREATE OR REPLACE FUNCTION main_org()
    returns trigger
    language plpgsql
as
$$
begin
    INSERT INTO tripsorganizer(trip_id, person_id) VALUES (new.id, new.main_organizer_id);
end;
$$;

DROP TRIGGER IF EXISTS tr_main_org ON trip;
CREATE TRIGGER tr_main_org
    AFTER INSERT
    ON trip
    FOR EACH ROW
EXECUTE PROCEDURE main_org();

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

insert into eventrating(person_id, trip_id, rating)
values (1, 3, 60);

delete from eventrating where person_id = 1 and trip_id = 3;

update eventrating set rating = 90 where person_id = 1 and trip_id = 1;


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

    raise notice 'New = %', new;

    select count(*)
    into people_count
    from settlement
    where new.house_id = settlement.house_id
      and new.trip_id = settlement.trip_id;


    if (house_capacity <= people_count) then
        raise exception 'Все места в доме заняты';
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_house_capacity ON settlement;
CREATE TRIGGER tr_house_capacity
    BEFORE INSERT OR UPDATE
    ON settlement
    FOR EACH ROW
EXECUTE PROCEDURE house_capacity();

insert into trip(name, description, start_date, finish_date, main_organizer_id)
values('Ya.Relax', 'GOAT', '2023-07-01', '2023-07-15', 3);

CREATE OR REPLACE FUNCTION disapprove_person()
    returns trigger
    language plpgsql
as
$$
begin
    if (tg_op = 'UPDATE' and new.approved = false) then
        delete
        from settlement
        where settlement.person_id = new.person_id
          and settlement.trip_id = new.trip_id;
    elsif (tg_op = 'DELETE') then
        delete
        from settlement
        where settlement.person_id = old.person_id
          and settlement.trip_id = old.trip_id;
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_disapprove_person ON tripsparticipants;
CREATE TRIGGER tr_disapprove_person
    AFTER UPDATE or DELETE
    ON tripsparticipants
    FOR EACH ROW
EXECUTE PROCEDURE disapprove_person();

update tripsparticipants set approved = false
where trip_id = 2 and person_id=3;

delete from tripsparticipants
where trip_id = 2 and person_id = 3;

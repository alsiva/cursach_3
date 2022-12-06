CREATE OR REPLACE FUNCTION insupd_overall_rating()
    returns trigger
    language plpgsql
as
$$
declare
    new_rating_sum   int;
    new_rating_count int;
begin
    if new is not null then
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


CREATE OR REPLACE FUNCTION change_event_rating()
    returns trigger
    language plpgsql
as
$$
begin
    if not (0 <= new.rating and new.rating <= 100) then
        raise EXCEPTION 'Рейтинг должен лежать в диапазоне [0; 100]';
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS change_event_rating ON eventrating;
CREATE TRIGGER change_event_rating
    BEFORE INSERT or UPDATE
    ON eventrating
    FOR EACH ROW
EXECUTE PROCEDURE change_event_rating();


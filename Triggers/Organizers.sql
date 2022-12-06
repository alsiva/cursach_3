CREATE OR REPLACE FUNCTION change_organizer()
    returns trigger
    language plpgsql
as
$$
begin
    if (select right_id from berrypeople where id = new.person_id) != 3 then
        raise EXCEPTION 'Извини, но у тебя нет прав организатора';
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_add_organizer ON tripsorganizer;
CREATE TRIGGER tr_add_organizer
    BEFORE INSERT or UPDATE
    ON tripsorganizer
    FOR EACH ROW
EXECUTE PROCEDURE change_organizer();
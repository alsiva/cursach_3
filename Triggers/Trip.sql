CREATE OR REPLACE FUNCTION update_schedule()
    returns trigger
    language plpgsql
as
$$
begin
    if (new.start_date > new.finish_date) then
        raise EXCEPTION 'Начальная дата должна быть раньше конечной';
    end if;

    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_update_trip ON trip;
CREATE TRIGGER tr_update_trip
    BEFORE INSERT or UPDATE
    ON trip
    FOR EACH ROW
EXECUTE PROCEDURE update_schedule();
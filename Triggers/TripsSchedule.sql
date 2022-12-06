CREATE OR REPLACE FUNCTION update_schedule()
    returns trigger
    language plpgsql
as
$$
declare
    start_event DATE;
    end_event   DATE;
begin
    if (new.start_time > new.end_time) then
        raise EXCEPTION 'Начальное время должно быть раньше конечного';
    end if;

    select start_date into start_event from trip where trip_id = new.trip_id;
    select finish_date into end_event from trip where trip_id = new.trip_id;

    if not (start_event <= new.start_time <= end_event)
        or not (start_event <= new.end_time <= end_event) then
        raise EXCEPTION 'Время мероприятия должно лежать в рамках выезда';
    end if;

    return new;
end;
$$;

DROP TRIGGER IF EXISTS tr_update_schedule ON tripschedule;
CREATE TRIGGER tr_update_schedule
    BEFORE INSERT or UPDATE
    ON tripschedule
    FOR EACH ROW
EXECUTE PROCEDURE update_schedule();
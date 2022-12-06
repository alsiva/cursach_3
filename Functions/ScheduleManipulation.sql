create or replace procedure make_schedule(
    event_id int,
    start_time timestamp,
    end_time timestamp,
    text text
)
    language plpgsql
as
$$
begin
    if (start_time > end_time) then
        raise EXCEPTION 'Начальное время должно быть раньше чем конечное';
    end if;
    INSERT intO tripschedule(trip_id, start_time, end_time, description)
    values (event_id, start_time, end_time, text);
end;
$$;

create or replace procedure remove_schedule(
    event_id int,
    start_event_time timestamp,
    end_event_time timestamp
)
    language plpgsql
as
$$
begin
    delete
    from tripschedule
    where trip_id = event_id
      and start_time = start_event_time
      and end_time = end_event_time;
end;
$$;

create or replace procedure update_schedule(
    event_id int,
    old_start_time timestamp,
    old_end_time timestamp,
    new_start_time timestamp,
    new_end_time timestamp,
    new_description text default null
)
    language plpgsql
as
$$
declare
    start_trip DATE;
    end_trip   DATE;
begin
    if new_start_time > new_end_time then
        raise EXCEPTION 'Начальное время мероприятия должно быть раньше конечного';
    end if;

    select start_date into start_trip from trip where trip.id = event_id;
    select finish_date into end_trip from trip where trip.id = event_id;

    if not (start_trip <= new_start_time and new_start_time <= end_trip)
        or not (start_trip <= new_end_time and new_end_time <= end_trip) then
        raise EXCEPTION 'Время мероприятия должно входить в даты выезда';
    end if;

    update tripschedule
    set start_time = new_start_time,
        end_time   = new_end_time
    where start_time = old_start_time
      and end_time = old_end_time
      and event_id = trip_id;

    if new_description IS NOT NULL then
        update tripschedule
        set description = new_description
        where start_time = new_start_time
          and end_time = new_end_time;
    end if;
end;
$$;

call update_schedule(2, '2022-11-14 22:00:00', '2022-11-14 23:00:00',
                     '2022-11-14 22:00:00', '2022-12-18 23:00:00');

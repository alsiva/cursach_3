create or replace procedure create_rating(
    event_id integer,
    participant_id integer,
    part_rating integer
)
    language plpgsql
as
$$
begin
    if not (0 <= part_rating and part_rating <= 100) then
        raise EXCEPTION 'Рейтинг должен лежать в диапазоне [0; 100]';
    end if;

    INSERT intO eventrating(person_id, trip_id, rating)
    VALUES (participant_id, event_id, part_rating);
end;
$$;

call create_rating(1, 4, 80);
call delete_rating(1, 4);

create or replace procedure update_rating(
    event_id int,
    participant_id int,
    value int
)
    language plpgsql
as
$$
begin
    if !(0 <= value <= 100) then
        raise EXCEPTION 'Рейтинг должен лежать в диапазоне [0; 100]';
    end if;

    update eventrating
    set rating = value
    where person_id = participant_id
      and trip_id = event_id;
end;
$$;

create or replace procedure delete_rating(
    event_id int,
    participant_id int
)
    language plpgsql
as
$$
begin
    delete
    from eventrating
    where person_id = participant_id
      and trip_id = event_id;
end;
$$

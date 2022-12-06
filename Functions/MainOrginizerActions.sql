create or replace procedure create_event(
    trip_name VARCHAR(50),
    trip_description VARCHAR(50),
    trip_start_date DATE,
    trip_end_date DATE,
    creator_id int
)
    language plpgsql
as
$$
begin
    if trip_start_date > trip_end_date then
        raise EXCEPTION 'Начальная дата должна быть раньше чем конечная';
    end if;
    if (select right_id from berrypeople where id = creator_id) = 3 then
        raise EXCEPTION 'Извините но у вас нету права организатора';
    end if;
    INSERT intO trip(name, description, start_date, finish_date, main_organizer_id)
    VALUES (trip_name, trip_description, trip_start_date, trip_end_date, creator_id);
end;
$$;

call create_event(
        'Выезд любителей лодок',
        'Лодки, баня, озеро',
        '2023-04-03',
        '2023-04-05',
        3
    );

create or replace procedure delete_event(
    event_id int
)
    language plpgsql
as
$$
begin
    delete from trip where id = event_id;
end;
$$;

call delete_event(2);

create or replace procedure add_organizer(
    event_id int,
    organizer_id int
)
    language plpgsql
as
$$
begin
    INSERT INTO tripsorganizer(trip_id, person_id)
    VALUES (event_id, organizer_id);
end;
$$;

create or replace procedure remove_organizer(
    event_id int,
    organizer_id int
)
    language plpgsql
as
$$
begin
    DELETE
    FROM tripsorganizer
    WHERE trip_id = event_id
      AND person_id = organizer_id;
end;
$$


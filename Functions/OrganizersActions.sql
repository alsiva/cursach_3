create or replace procedure add_person_to_event(
    participant_id int,
    event_id int
)
    language plpgsql
as
$$
begin
    if (select right_id from berrypeople where id = participant_id) = 2 then
        raise EXCEPTION 'Извини, но ты в бане';
    end if;
    UPDATE tripsparticipants
    SET approved = true
    WHERE person_id = participant_id
      AND trip_id = event_id;
end;
$$;

call add_person_to_event(4, 1);

create or replace procedure settle_in_person(
    participant_id int,
    event_id int,
    settle_house_id int
)
    language plpgsql
as
$$
begin
    if (select count(*)
        from settlement
        where house_id = settle_house_id
          and trip_id = event_id)
        >= (select maxpeople from house where id = settle_house_id) then
        raise EXCEPTION 'Места в доме закончились';
    end if;
    INSERT intO settlement(trip_id, person_id, house_id)
    VALUES (event_id, participant_id, settle_house_id);
end;
$$;

call settle_in_person(4, 1, 1);

create or replace procedure ban_person(
    ban_id int
)
    language plpgsql
as
$$
begin
    UPDATE berrypeople
    SET right_id = 2
    WHERE id = ban_id;
end;
$$;

call ban_person(1);

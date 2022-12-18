create or replace function get_sorted_requests(
    trip_id_arg integer
)
    returns table
            (
                person_id  integer,
                rating     integer,
                letter     varchar(1000),
                first_name varchar(50),
                last_name  varchar(50)
            )
    language plpgsql
as
$$
begin
    return query (select id, overallrating.rating, tripsparticipants.letter, name, surname
                  from berrypeople
                           inner join tripsparticipants
                                      on trip_id_arg = tripsparticipants.trip_id and id = tripsparticipants.person_id
                           left join overallrating on id = overallrating.person_id
                  order by overallrating.rating desc);
end;
$$;

select get_sorted_requests(1);

create or replace function get_settlement(
    trip_id_arg integer
)
    returns table
            (
                person_id integer,
                fname     varchar(50),
                sname     varchar(50),
                house_id  integer,
                hname     varchar(50)
            )
    language plpgsql
as
$$
begin
    return query (select settlement.person_id, berrypeople.name, berrypeople.surname, house.id, house.name
                  from settlement
                           inner join berrypeople on settlement.person_id = berrypeople.id
                           left join house on settlement.house_id = house.id
                  where settlement.trip_id = trip_id_arg);
end;
$$;

select get_settlement(1);



create or replace function get_unrated(
    trip_id_arg integer
)
    returns table
            (
                trip_id   integer,
                person_id integer,
                fname     varchar(50),
                sname     varchar(50)
            )
    language plpgsql
as
$$
begin
    return query (select tripsparticipants.trip_id, tripsparticipants.person_id, name, surname
                  from tripsparticipants
                           inner join berrypeople on tripsparticipants.person_id = berrypeople.id
                           left join eventrating on tripsparticipants.person_id = eventrating.person_id and
                                                    trip_id_arg = eventrating.trip_id
                  where eventrating.person_id IS NULL);
end;
$$;

select get_unrated(1)

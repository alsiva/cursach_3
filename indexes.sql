create index if not exists settlement_index
    on settlement(house_id);

create index if not exists people_index
    on berrypeople(right_id);

create index if not exists tripsparticipants_index
    on tripsparticipants(trip_id);

create index if not exists tripsorganizer_index
    on tripsorganizer(trip_id);
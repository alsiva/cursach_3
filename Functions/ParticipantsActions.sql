create or replace procedure register(
    name VARCHAR(50),
    surname VARCHAR(50),
    password VARCHAR(50),
    sex gender,
    dob DATE,
    telegram VARCHAR(50),
    vk VARCHAR(50)
)
    language plpgsql
as
$$
begin
    INSERT intO berrypeople(right_id, password, name, surname, sex, date_of_birth, telegram, vk)
    VALUES (1, password, name, surname, sex, dob, telegram, vk);
end;
$$;

call register(
        'Maxim',
        'Kuznetsov',
        'kl_jiMst',
        'man',
        '2003-05-28',
        '@maxalkuz',
        'https://vk.com/icerzack'
    );


create or replace procedure register_on_event(
    participant_id int,
    event_id int,
    mot_letter VARCHAR(1000)
)
    language plpgsql
as
$$
begin
    INSERT intO tripsparticipants(trip_id, person_id, letter, approved)
    VALUES (event_id, participant_id, mot_letter, FALSE);
end;
$$;

call register_on_event(
        4,
        2,
        'Очень давно хотел попасть на ваш хакатон, ' ||
        'считал ягодное пустой тратой времени, ' ||
        'однако мой друг Алексей просвятил меня в том что это такое ' ||
        'и я с большим удовольствием поеду в этот лагерь' ||
        ' и выступлю в роли мобильного разработчика'
    );

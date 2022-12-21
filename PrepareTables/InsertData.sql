INSERT INTO rights(name)
VALUES ('normal'),
       ('banned'),
       ('upgraded');

INSERT INTO berrypeople(right_id, password, name, surname, sex, date_of_birth, telegram, vk)
VALUES (1, 'Lit23_Quv', 'Ivan', 'Zhamkov', 'man', '2002-02-21', '@zhamkov', '@zhamkov'),
       (1, '_81nqFgk', 'Sonya', 'Klyuchnikova', 'woman', '2001-05-26', '@KeySonya', '@KeySonya'),
       (3, 'rt_97JnQk', 'Alexei', 'Ivanov', 'man', '2002-03-23', '@leshanov', '@leshanov');


INSERT INTO triptype(name)
VALUES ('Holiday'),
       ('Workshop'),
       ('Multi-University trip'),
       ('Education');

INSERT INTO trip(name, description, start_date, finish_date, main_organizer_ID)
VALUES ('Halloween', 'Halloween party of PIICT', '2022-10-29', '2022-11-01', 3),
       ('November hackathon', 'Programming hackaton', '2022-11-10', '2022-11-15', 3);

INSERT INTO tripreltype (Trip_ID, Type_ID)
VALUES (1, 1),
       (2, 3),
       (2, 2),
       (2, 4);

INSERT INTO eventrating (Person_ID, Trip_ID, Rating)
VALUES (1, 1, 10),
       (2, 1, 5),
       (3, 2, 7);

INSERT INTO house (Name, maxPeople)
VALUES ('4-bed-room-yellow', 4),
       ('2-bed-room-red', 2),
       ('3-bed-room-blue', 3);

INSERT INTO tripsparticipants(trip_id, person_id, letter, approved)
VALUES (1, 1, 'Очень хочу попасть на данный выезд, позвали друзья', FALSE),
       (1, 2, 'Хотела бы поплавать на лодочках, познать гармонию природы', TRUE),
       (1, 3, 'Как истинный Волк ВТ хочу прославить нашу стаю', TRUE),
       (2, 1, 'Хочу прокачать свои программистские навыки, поработать в комманде сильных ребят', FALSE),
       (2, 2, 'Хотела хорошо бы провести время', FALSE),
       (2, 3, 'Хотел бы ворваться в атмосферу хакатона', TRUE);

INSERT INTO settlement(trip_id, person_id, house_id)
VALUES (1, 1, 2),
       (1, 2, 3),
       (1, 3, 2),
       (2, 1, 1),
       (2, 2, 2),
       (2, 3, 3);

INSERT INTO tripSchedule(trip_id, start_time, end_time, description)
VALUES (1, '2022-10-29 11:00:00', '2022-10-29 12:00:00', 'Поселение участников ивента'),
       (1, '2022-10-29 14:00:00', '2022-10-29 16:00:00', 'Обед'),
       (1, '2022-10-29 18:00:00', '2022-10-29 19:00:00', 'Чиллим'),
       (1, '2022-10-30 22:00:00', '2022-10-31 06:00:00', 'Тусовка'),
       (1, '2022-10-31 16:00:00', '2022-10-31 18:00:00', 'Обед'),
       (1, '2022-11-01 11:00 AM', '2022-11-01 13:00:00', 'Уходим');
INSERT INTO tripschedule(trip_id, start_time, end_time, description)
VALUES (2, '2022-11-10 11:00:00', '2022-11-10 12:00:00', 'Поселение участников ивента'),
       (2, '2022-11-10 14:00:00', '2022-11-10 16:00:00', 'Обед'),
       (2, '2022-11-10 18:00:00', '2022-11-10 20:00:00', 'Лекция'),
       (2, '2022-11-11 10:00:00', '2022-11-11 12:00:00', 'Торжественное открытие хакатона'),
       (2, '2022-11-14 16:00:00', '2022-11-14 18:00:00', 'Закрытие хакатона и награждщние'),
       (2, '2022-11-15 11:00:00', '2022-11-15 13:00:00', 'Уходим');
INSERT INTO tripsorganizer(trip_id, person_id)
VALUES (1, 2),
       (2, 1),
       (2, 3);

INSERT INTO overallrating(person_id, rating)
VALUES (1, 60),
       (2, 80),
       (3, 100)

CREATE TYPE gender AS ENUM ('man','woman');

CREATE TABLE IF NOT EXISTS rights
(
  id SERIAL UNIQUE,
  name VARCHAR(50) UNIQUE,
  PRIMARY KEY(id,name)
);

CREATE TABLE IF NOT EXISTS berrypeople
(
  id Serial PRIMARY KEY,
  Right_ID INT NOT NULL REFERENCES rights (id) ON DELETE SET NULL,
  name VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  password VARCHAR(50) UNIQUE NOT NULL,
  sex gender,
  date_of_birth DATE NOT NULL,
  telegram VARCHAR(50),
  vk VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS triptype
(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS trip
(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL check ( start_date < trip.finish_date ),
  finish_date DATE NOT NULL check ( finish_date > trip.start_date ),
  main_organizer_ID INT NOT NULL REFERENCES berrypeople (id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS tripreltype
(
  Type_ID INT NOT NULL,
  Trip_ID INT NOT NULL,
  PRIMARY KEY(Type_ID, Trip_ID),
  CONSTRAINT fk_triptypes FOREIGN KEY (Type_ID) REFERENCES triptype(id) ON DELETE CASCADE,
  CONSTRAINT fk_trip FOREIGN KEY (Trip_ID) REFERENCES trip (id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS eventrating
(
  Person_ID INT NOT NULL,
  Trip_ID INT NOT NULL,
  Rating INT check ( 0 <= Rating and Rating <= 100 ),
  PRIMARY KEY(Person_ID,Trip_ID),
  FOREIGN KEY (Person_ID) REFERENCES berrypeople (id) ON DELETE CASCADE,
  FOREIGN KEY (Trip_ID) REFERENCES trip (id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS overallrating
(
  Person_ID INT NOT NULL REFERENCES berrypeople (id) ON DELETE CASCADE,
  Rating INT check ( 0 <= Rating and Rating <= 100 ),
  PRIMARY KEY(Person_ID)
);
CREATE TABLE IF NOT EXISTS house
(
  id SERIAL PRIMARY KEY,
  Name VARCHAR(50) NOT NULL,
  maxPeople INT NOT NULL check ( maxPeople >= 0 )
);
CREATE TABLE IF NOT EXISTS tripsparticipants
(
    Trip_ID INT NOT NULL REFERENCES trip (id) ON DELETE CASCADE,
    Person_ID INT NOT NULL REFERENCES berrypeople (id) ON DELETE CASCADE,
    Letter VARCHAR(1000),
    approved BOOLEAN
);
CREATE TABLE IF NOT EXISTS settlement
(
  Trip_ID INT NOT NULL REFERENCES trip (id) ON DELETE CASCADE,
  Person_ID INT NOT NULL REFERENCES berrypeople (id) ON DELETE CASCADE,
  House_ID INt NOT NULL REFERENCES house (id) ON DELETE CASCADE,
  PRIMARY KEY(Trip_ID,Person_ID,House_ID)
);
CREATE TABLE IF NOT EXISTS tripschedule(
  Trip_ID INT NOT NULL REFERENCES trip (id) ON DELETE CASCADE,
  start_time TIMESTAMP NOT NULL check ( start_time < tripschedule.end_time ),
  end_time TIMESTAMP NOT NULL check ( end_time > tripschedule.start_time ),
  description TEXT,
  PRIMARY KEY (Trip_ID, start_time, end_time)
);
CREATE TABLE IF NOT EXISTS tripsorganizer(
  Trip_ID INT NOT NULL REFERENCES trip (id) ON DELETE CASCADE,
  Person_ID INT NOT NULL REFERENCES berrypeople (id) ON DELETE CASCADE,
  PRIMARY KEY(Trip_ID, Person_ID)
);

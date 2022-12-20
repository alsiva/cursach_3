CREATE TYPE gender AS ENUM ('man','woman');

CREATE TABLE IF NOT EXISTS Rights(
  id SERIAL UNIQUE,
  name VARCHAR(50) UNIQUE,
  PRIMARY KEY(id,name)
);

CREATE TABLE IF NOT EXISTS BerryPeople(
  id Serial PRIMARY KEY,
  Right_ID INT NOT NULL REFERENCES Rights(id) ON DELETE SET NULL,
  name VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  password VARCHAR(50) UNIQUE NOT NULL,
  sex gender,
  date_of_birth DATE NOT NULL,
  telegram VARCHAR(50),
  vk VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS TripType(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS Trip(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL check ( start_date < Trip.finish_date ),
  finish_date DATE NOT NULL check ( finish_date > Trip.start_date ),
  main_organizer_ID INT NOT NULL REFERENCES BerryPeople(id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS TripRelType(
  Type_ID INT NOT NULL,
  Trip_ID INT NOT NULL,
  PRIMARY KEY(Type_ID, Trip_ID),
  CONSTRAINT fk_triptypes FOREIGN KEY (Type_ID) REFERENCES TripType(id) ON DELETE CASCADE,
  CONSTRAINT fk_trip FOREIGN KEY (Trip_ID) REFERENCES trip(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS EventRating(
  Person_ID INT NOT NULL,
  Trip_ID INT NOT NULL,
  Rating INT check ( 0 <= Rating and Rating <= 100 ),
  PRIMARY KEY(Person_ID,Trip_ID),
  FOREIGN KEY (Person_ID) REFERENCES BerryPeople(id) ON DELETE CASCADE,
  FOREIGN KEY (Trip_ID) REFERENCES Trip(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS OverallRating(
  Person_ID INT NOT NULL REFERENCES BerryPeople(id) ON DELETE CASCADE,
  Rating INT check ( 0 <= Rating and Rating <= 100 ),
  PRIMARY KEY(Person_ID)
);
CREATE TABLE IF NOT EXISTS House(
  id SERIAL PRIMARY KEY,
  Name VARCHAR(50) NOT NULL,
  maxPeople INT NOT NULL check ( maxPeople >= 0 )
);
CREATE TABLE IF NOT EXISTS TripsParticipants(
    Trip_ID INT NOT NULL REFERENCES Trip(id) ON DELETE CASCADE,
    Person_ID INT NOT NULL REFERENCES BerryPeople(id) ON DELETE CASCADE,
    Letter VARCHAR(1000),
    approved BOOLEAN
);
CREATE TABLE IF NOT EXISTS Settlement(
  Trip_ID INT NOT NULL REFERENCES Trip(id) ON DELETE CASCADE,
  Person_ID INT NOT NULL REFERENCES BerryPeople(id) ON DELETE CASCADE,
  House_ID INt NOT NULL REFERENCES House(id) ON DELETE CASCADE,
  PRIMARY KEY(Trip_ID,Person_ID,House_ID)
);
CREATE TABLE IF NOT EXISTS TripSchedule(
  Trip_ID INT NOT NULL REFERENCES Trip(id) ON DELETE CASCADE,
  start_time TIMESTAMP NOT NULL check ( start_time < TripSchedule.end_time ),
  end_time TIMESTAMP NOT NULL check ( end_time > TripSchedule.start_time ),
  description TEXT,
  PRIMARY KEY (Trip_ID, start_time, end_time)
);
CREATE TABLE IF NOT EXISTS TripsOrganizer(
  Trip_ID INT NOT NULL REFERENCES Trip(id) ON DELETE CASCADE,
  Person_ID INT NOT NULL REFERENCES BerryPeople(id) ON DELETE CASCADE,
  PRIMARY KEY(Trip_ID, Person_ID)
);
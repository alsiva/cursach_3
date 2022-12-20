import psycopg2
import random
import datetime
import numpy as np
from faker import Faker

fake = Faker('ru_RU')
try:
    conn = psycopg2.connect(user='postgres',
                            password='Gungun124',
                            host='127.0.0.1',
                            port='8888',
                            database='yagodnoye')

    cursor = conn.cursor()
    postgres_create_berry_people_query = """ INSERT INTO trip (name, description, start_date,finish_date, main_organizer_ID) VALUES(%s,%s,%s,%s,%s)"""
    for i in range(36):
        start_date = fake.date_between(start_date = "-1y")
        end_date = start_date + datetime.timedelta(days=5)
        record_to_insert = (fake.words(nb=1, unique=True), fake.sentence(nb_words = 4), start_date, end_date, random.randint(1,40))
        cursor.execute(postgres_create_berry_people_query, record_to_insert)
    conn.commit()
    count = cursor.rowcount
    print(count)

except (Exception, psycopg2.Error) as error:
    print("Failed to insert record", error)

finally:
    if conn:
        cursor.close()
        conn.close()
        print("Postgres connection closed") 


import psycopg2
import random
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
    postgres_create_berry_people_query = """ INSERT INTO tripparticipant (trip_id, person_id, letter, approved) VALUES (%s,%s, %s, %s)"""
    for i in range(36):
        for j in range(100):
            approved = np.random.choice([True,False],p=(0.5,0.5))
            record_to_insert = (i+1, random.randint(2,340), fake.paragraph(), bool(approved))
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


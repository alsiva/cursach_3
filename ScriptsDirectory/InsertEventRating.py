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
    postgres_create_berry_people_query = """ INSERT INTO eventrating (Person_ID,Trip_Id,Rating) VALUES (%s,%s,%s)"""
    for i in range(36):
        record_to_insert = (random.randint(1,340),random.randint(1,36),random.randint(1,10))
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


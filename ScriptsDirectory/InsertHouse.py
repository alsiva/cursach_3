import psycopg2
import random
import numpy as np
from faker import Faker

fake = Faker('ru_RU')
try:
    conn = psycopg2.connect(user='postgres',
                            password='5635',
                            host='localhost',
                            port='5433',
                            database='postgres')

    cursor = conn.cursor()
    postgres_create_berry_people_query = """ INSERT INTO house (name, maxPeople) VALUES (%s,%s)"""
    for i in range(10):
        color = fake.color_name()
        size = random.randint(1,5)
        record_to_insert = (str(size) + '_bedroom_house_' + color, size)
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


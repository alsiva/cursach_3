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
    #TripType 
    categories = ['Учебный', 'Праздничный','Хакатон', 'Благотворительный','Спортивный','Творческий','Научный']
    postgres_add_trip_types = """ INSERT INTO triptype(name) VALUES (%s) """

    for i in range(len(categories) - 1):
        record_to_insert = categories[i]
        cursor.execute(postgres_add_trip_types, (record_to_insert,))
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


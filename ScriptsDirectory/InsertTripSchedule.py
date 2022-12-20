import psycopg2
import random
import numpy as np
import datetime
from faker import Faker
import sys

fake = Faker('ru_RU')
try:
    conn = psycopg2.connect(user='postgres',
                            password='Gungun124',
                            host='127.0.0.1',
                            port='8888',
                            database='yagodnoye')

    cursor = conn.cursor()
    cursor2 = conn.cursor()
    list = ['Приходим','Поселение участников ивента','Открытие','Завтрак','Чиллим','Тусовка','Обед','Ужин','Кодим','Отдых','Музыка','Спорт']
    postgres_create_berry_people_query = """ INSERT INTO tripschedule (trip_id, start_time,end_time,description) VALUES (%s,%s, %s, %s)"""
    postgres_get_start_date_query = """SELECT start_date FROM trip WHERE id = %d"""
    
    for i in range(1,36):
        cursor.execute(postgres_get_start_date_query % i)
        start_date = cursor.fetchall()[0][0]
        date = datetime.datetime(start_date.year, start_date.month, start_date.day, 00,00)
        for k in range(5):
            date = datetime.datetime(date.year, date.month, date.day, 8,00)
            for j in range(5):
                date2 = date + datetime.timedelta(hours=2)
                index = random.randint(0,len(list)-1)
                record_to_insert = (str(i), str(date), str(date2), list[index])
                cursor2.execute(postgres_create_berry_people_query, record_to_insert)
                date += datetime.timedelta(hours = 3)
            date += datetime.timedelta(days = 1)
    conn.commit()

except (Exception, psycopg2.Error) as error:
    print("Failed to insert record", error)

finally:
    if conn:
        cursor.close()
        conn.close()
        print("Postgres connection closed") 


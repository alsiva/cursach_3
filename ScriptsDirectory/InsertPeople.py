import psycopg2
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
    postgres_create_berry_people_query = """ INSERT INTO berryperson (Right_id,name,surname,password,sex, date_of_birth,telegram,vk) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)"""
    for i in range(350):
        sex = np.random.choice(['man','woman'], p=[0.5,0.5])
        if sex == 'man': 
            first_name = fake.first_name_male()
        else:
            first_name = fake.first_name_female()
        if i < 340:
            record_to_insert = (2, first_name, fake.last_name(), fake.password(), sex, fake.date_between(start_date = '-25y', end_date = '-18y'), '@' + fake.user_name(), 'https://vk.com/' + fake.user_name())
        else:
            record_to_insert = (3, first_name, fake.last_name(), fake.password(), sex, fake.date_between(start_date = '-25y', end_date = '-18y'), '@' + fake.user_name(), 'https://vk.com/' + fake.user_name())
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


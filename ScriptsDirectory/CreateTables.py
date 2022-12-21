import psycopg2

try:
    conn = psycopg2.connect(user='postgres',
                            password='5635',
                            host='localhost',
                            port='5433',
                            database='postgres')

    cursor = conn.cursor()
    cursor.execute(open("Create_tables.sql","r").read())
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


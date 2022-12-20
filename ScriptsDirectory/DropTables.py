import psycopg2

try:
    conn = psycopg2.connect(user='postgres',
                            password='Gungun124',
                            host='127.0.0.1',
                            port='8888',
                            database='yagodnoye')

    cursor = conn.cursor()
    cursor.execute(open("DropTables.sql","r").read())
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


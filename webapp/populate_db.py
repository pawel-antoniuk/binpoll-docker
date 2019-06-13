import glob
import mysql.connector
import os

db = mysql.connector.connect(
        host=os.environ['BINPOLL_DB_HOST'],
        port=os.environ['BINPOLL_DB_PORT'],
        user=os.environ['BINPOLL_DB_USER'],
        passwd=os.environ['BINPOLL_DB_PASS'],
        database=os.environ['BINPOLL_DB_NAME'])

cursor = db.cursor()
insert_sql = 'insert into data_collector_audiosample (filepath) values (%s)'
delete_sql = 'delete from data_collector_audiosample'

cursor.execute(delete_sql)

for file in glob.glob('poll_sounds/*'):
    filename = os.path.basename(file)
    print('inserted ', filename)
    cursor.execute(insert_sql, (filename,))

db.commit()


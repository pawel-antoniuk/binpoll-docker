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

sql_insert_audiosample = 'insert into data_collector_audiosample (filepath) values (%s)'
sql_insert_audioset = 'insert into data_collector_audioset (id) values (1)'
sql_insert_audioset_samples = 'insert into data_collector_audioset_samples (audioset_id, audiosample_id) values (%s, %s)'

sql_delete_audiosample = 'delete from data_collector_audiosample'
sql_delete_audioset = 'delete from data_collector_audioset'
sql_delete_audioset_samples = 'delete from data_collector_audioset_samples'

cursor.execute(sql_delete_audioset_samples)
cursor.execute(sql_delete_audioset)
cursor.execute(sql_delete_audiosample)

cursor.execute(sql_insert_audioset)
audioset_id = cursor.lastrowid

for file in glob.glob('poll_sounds/*'):
    filename = os.path.basename(file)
    print('inserted ', filename)
    cursor.execute(sql_insert_audiosample, (filename,))
    audiosample_id = cursor.lastrowid
    cursor.execute(sql_insert_audioset_samples, (audioset_id, audiosample_id))

db.commit()




import glob
import mysql.connector
import os
import random

db = mysql.connector.connect(
        host=os.environ['BINPOLL_DB_HOST'],
        port=os.environ['BINPOLL_DB_PORT'],
        user=os.environ['BINPOLL_DB_USER'],
        passwd=os.environ['BINPOLL_DB_PASS'],
        database=os.environ['BINPOLL_DB_NAME'])

cursor = db.cursor()

sql_select_audioset = 'select count(*) from data_collector_audioset where id = 1'
sql_insert_audiosample = 'insert into data_collector_audiosample (filepath) values (%s)'
sql_insert_audioset = 'insert into data_collector_audioset (id) values (1)'
sql_insert_audioset_samples = 'insert into data_collector_audioset_samples (audioset_id, audiosample_id) values (%s, %s)'

cursor.execute(sql_select_audioset)
(number_of_rows,)=cursor.fetchone()

if number_of_rows < 1:
    cursor.execute(sql_insert_audioset)
    audioset_id = cursor.lastrowid

    filenames = set()
    file_count = 0
    for file in glob.glob('poll_sounds/*'):
        if(file_count >= 30):
            break
        file_count += 1
        filename = os.path.basename(file)
        filename = '_'.join(filename.split('_')[:-2])
        filenames.add(filename)
    
    filenames = list(filenames)
    random.Random(125).shuffle(filenames)

    for filename in filenames:
        print('inserted ', filename)
        cursor.execute(sql_insert_audiosample, (filename,))
        cursor.execute(sql_insert_audioset_samples, (audioset_id, filename))

    db.commit()

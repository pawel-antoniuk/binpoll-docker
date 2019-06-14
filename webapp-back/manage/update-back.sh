#!/bin/bash
apache2ctl stop 
(cd "$BINPOLL_BACK_SRC"; git pull)
(source /app/venv/bin/activate; \
     python "$BINPOLL_BACK_SRC"/manage.py collectstatic --noinput; \
     python "$BINPOLL_BACK_SRC"/manage.py makemigrations data_collector; \
     python "$BINPOLL_BACK_SRC"/manage.py migrate)
apache2ctl start


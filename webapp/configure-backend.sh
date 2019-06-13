#!/bin/bash

cd "$BINPOLL_BACK_SRC"/binpoll_back \
    && . /app/venv/bin/activate \
    && python manage.py collectstatic --noinput \
    && python manage.py makemigrations data_collector \
    && python manage.py migrate \
    && cd /app && python populate_db.py \
    && ln -s "$BINPOLL_BACK_SRC"/binpoll_back "$BINPOLL_BACK_TARGET" \
    && ln -s /app/poll_sounds "$BINPOLL_BACK_SRC"/binpoll_back/static \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2dissite 000-default \
    && a2ensite binpoll-front \
    && a2ensite binpoll-back \
    && apache2ctl start \
    && tail -f /dev/null
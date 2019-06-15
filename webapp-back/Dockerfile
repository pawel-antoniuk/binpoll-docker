FROM pantoniuk/binpoll-back-host
WORKDIR /app

ARG BINPOLL_DB_HOST
ARG BINPOLL_DB_NAME
ARG BINPOLL_DB_USER
ARG BINPOLL_DB_PASS
ARG BINPOLL_DB_PORT

ENV BINPOLL_DB_HOST=${BINPOLL_DB_HOST}
ENV BINPOLL_DB_NAME=${BINPOLL_DB_NAME}
ENV BINPOLL_DB_USER=${BINPOLL_DB_USER}
ENV BINPOLL_DB_PASS=${BINPOLL_DB_PASS}
ENV BINPOLL_DB_PORT=${BINPOLL_DB_PORT}

ENV DEBIAN_FRONTEND noninteractive
ENV BINPOLL_BACK_TARGET /var/www/binpoll-back
ENV BINPOLL_BACK_SRC /app/binpoll-back

# copy applications and data files
COPY create-superuser.sh    /app/
COPY binpoll-back.conf      /etc/apache2/sites-available/
COPY wait-for-it.sh         /app/
COPY configure.sh           /app/
COPY binpoll-back           ${BINPOLL_BACK_SRC}
COPY populate_db.py         /app/
ADD  poll_sounds.tar        /app/

EXPOSE 80

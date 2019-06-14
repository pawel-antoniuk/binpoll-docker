FROM ubuntu:18.04
WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive
ENV BINPOLL_BACK_TARGET /var/www/binpoll-back
ENV BINPOLL_BACK_SRC /app/binpoll-back

ENV BINPOLL_DB_NAME=binpoll
ENV BINPOLL_DB_USER=binpoll
ENV BINPOLL_DB_PASS=binpoll
ENV BINPOLL_DB_PORT=3306

# copy installation scripts
COPY create-superuser.sh /app/
COPY requirements.txt /app/

# install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y apache2 python3 python3-pip libapache2-mod-wsgi-py3 libmysqlclient-dev \
    && ln -sfn /usr/bin/python3.6 /usr/bin/python \
    && ln -sfn /usr/bin/pip3 /usr/bin/pip \
    && pip install virtualenv

# configure python virtual env
RUN virtualenv /app/venv \ 
    && . /app/venv/bin/activate \
    && pip install -r /app/requirements.txt

# copy applications and data files
COPY binpoll-back.conf      /etc/apache2/sites-available/
COPY ports.conf             /etc/apache2/
COPY wait-for-it.sh         /app/
COPY configure.sh   /app/
COPY binpoll-back           ${BINPOLL_BACK_SRC}
COPY populate_db.py         /app/
ADD  poll_sounds.tar        /app/

EXPOSE 80

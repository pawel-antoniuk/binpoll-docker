FROM ubuntu:18.04
WORKDIR /app

ARG BINPOLL_FRONT_TARGET=/var/www/binpoll-front
ARG BINPOLL_BACK_TARGET=/var/www/binpoll-back
ARG BINPOLL_FRONT_SRC=/app/binpoll-front
ARG BINPOLL_BACK_SRC=/app/binpoll-back

ENV DEBIAN_FRONTEND noninteractive
ENV BINPOLL_FRONT_TARGET ${BINPOLL_FRONT_TARGET}
ENV BINPOLL_BACK_TARGET ${BINPOLL_BACK_TARGET}
ENV BINPOLL_FRONT_SRC ${BINPOLL_FRONT_SRC}
ENV BINPOLL_BACK_SRC ${BINPOLL_BACK_SRC}

ENV BINPOLL_DB_NAME=binpoll
ENV BINPOLL_DB_USER=binpoll
ENV BINPOLL_DB_PASS=binpoll
ENV BINPOLL_DB_PORT=3306
ENV BINPOLL_DB_HOST=database

EXPOSE 80 8000

# copy installation scripts
COPY node_setup_10.sh /app/

# install dependencies
RUN cat /app/node_setup_10.sh | bash \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y apache2 python3 python3-pip nodejs libapache2-mod-wsgi-py3 libmysqlclient-dev \
    && ln -sfn /usr/bin/python3.6 /usr/bin/python \
    && ln -sfn /usr/bin/pip3 /usr/bin/pip \
    && pip install virtualenv

# configure python virtual env
RUN virtualenv /app/venv \ 
    && . /app/venv/bin/activate \
    && pip install django coreapi django-rest-framework django-cors-headers mysql-connector mysqlclient

# copy applications and data files
COPY binpoll-front.conf     /etc/apache2/sites-available/
COPY binpoll-back.conf      /etc/apache2/sites-available/
COPY ports.conf             /etc/apache2/
COPY wait-for-it.sh         /app/
COPY configure-backend.sh   /app/
COPY binpoll-front          ${BINPOLL_FRONT_SRC}
COPY binpoll-back           ${BINPOLL_BACK_SRC}
COPY populate_db.py         /app/
ADD  poll_sounds.tar        /app/

# build and mount frontend
RUN cd ${BINPOLL_FRONT_SRC} \
    && npm install \
    && npm run ng build \
    && ln -s ${BINPOLL_FRONT_SRC}/dist/binpoll-front ${BINPOLL_FRONT_TARGET}

#CMD ["./wait-for-it.sh", "database:3306", "-t", "20", "--", "bash", "/app/configure-backend.sh"]

#ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]


#RUN apk add bash openrc apache2
#CMD ["bash"]EXPOSE 80

#FROM httpd:2.4-alpine
#WORKDIR /app
#COPY . /app

#RUN apk add bash openrc
#CMD ["bash"]

#RUN pip install --trusted-host pypi.python.org -r requirements.txt
#EXPOSE 80
#ENV NAME World
#CMD ["python", "app.py"]

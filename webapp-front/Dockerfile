FROM ubuntu:18.04
WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive
ENV BINPOLL_FRONT_TARGET /var/www/binpoll-front
ENV BINPOLL_FRONT_SRC /app/binpoll-front
ENV BINPOLL_API_URL=http://audio.wi.pb.edu.pl:8000/
ENV BINPOLL_SOUND_URL=${BINPOLL_API_URL}/static/poll_sounds/

# copy installation scripts and config files
COPY node_setup_10.sh       /app/
COPY update-front-config.sh /app/
COPY binpoll-front.conf     /etc/apache2/sites-available/
COPY binpoll-front          ${BINPOLL_FRONT_SRC}

# install dependencies
RUN cat /app/node_setup_10.sh | bash \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y apache2 nodejs

COPY ports.conf /etc/apache2/

# build and mount frontend
RUN cd ${BINPOLL_FRONT_SRC} \
    && npm install \
    && npm run ng build \
    && ln -s ${BINPOLL_FRONT_SRC}/dist/binpoll-front ${BINPOLL_FRONT_TARGET} \
    && /app/update-front-config.sh \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2dissite 000-default \
    && a2ensite binpoll-front

CMD ["apachectl", "-D", "FOREGROUND"]

EXPOSE 80

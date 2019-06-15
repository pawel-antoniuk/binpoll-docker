FROM pantoniuk/binpoll-front-host
WORKDIR /app

ARG BINPOLL_API_URL

ENV DEBIAN_FRONTEND noninteractive
ENV BINPOLL_FRONT_TARGET /var/www/binpoll-front
ENV BINPOLL_FRONT_SRC /app/binpoll-front
ENV BINPOLL_API_URL ${BINPOLL_API_URL}
ENV BINPOLL_SOUND_URL ${BINPOLL_API_URL}/static/poll_sounds/

# copy installation scripts and config files
COPY update-front-config.sh /app/
COPY binpoll-front.conf     /etc/apache2/sites-available/
COPY binpoll-front          ${BINPOLL_FRONT_SRC}

# build and mount frontend
RUN cd ${BINPOLL_FRONT_SRC} \
    && npm install \
    && /app/update-front-config.sh \
    && npm run ng build \
    && ln -s ${BINPOLL_FRONT_SRC}/dist/binpoll-front ${BINPOLL_FRONT_TARGET} \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2dissite 000-default \
    && a2ensite binpoll-front

CMD ["apachectl", "-D", "FOREGROUND"]

EXPOSE 80

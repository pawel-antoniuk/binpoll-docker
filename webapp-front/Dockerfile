FROM pantoniuk/binpoll-front-host
WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive
ENV BINPOLL_FRONT_TARGET /var/www/binpoll-front
ENV BINPOLL_FRONT_SRC /app/binpoll-front
ENV BINPOLL_API_URL http://localhost:8000/

# copy installation scripts and config files
COPY update-front-config.sh /app/
COPY configure.sh /app/
COPY binpoll-front.conf     /etc/apache2/sites-available/
COPY binpoll-front          ${BINPOLL_FRONT_SRC}

# build and mount frontend
RUN cd ${BINPOLL_FRONT_SRC} \
    && npm install \
    && npm run ng build \
    && ln -s ${BINPOLL_FRONT_SRC}/dist/binpoll-front ${BINPOLL_FRONT_TARGET} \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2dissite 000-default \
    && a2ensite binpoll-front

CMD ["bash", "/app/configure.sh"]

EXPOSE 80

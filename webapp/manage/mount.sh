#!/bin/bash

mount --bind binpoll-front/dist/binpoll-front/ /var/www/binpoll-front
mount --bind binpoll-back/binpoll_back /var/www/binpoll-back

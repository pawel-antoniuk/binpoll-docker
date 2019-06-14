#!/bin/bash
apache2ctl stop
(cd "$BINPOLL_BACK_SRC"; git pull)
(cd "$BINPOLL_BACK_SRC"; npm run ng build --prod)
apache2ctl start


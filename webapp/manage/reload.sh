#!/bin/bash
service apache2 stop
./umount.sh
./umount_poll_sounds.sh
(cd binpoll-front; git pull)
(cd binpoll-back; git pull)
(cd binpoll-front; npm run ng build --prod)
(cd binpoll-back; source binpoll_back/venv/bin/activate; python binpoll_back/manage.py collectstatic --noinput)
(cd binpoll-back; source binpoll_back/venv/bin/activate; python binpoll_back/manage.py makemigrations)
(cd binpoll-back; source binpoll_back/venv/bin/activate; python binpoll_back/manage.py migrate)
./mount.sh
./mount_poll_sounds.sh
service apache2 start



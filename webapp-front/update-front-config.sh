#!/bin/bash

config_data="{\"apiUrl\":$BINPOLL_API_URL \"pollSoundsUrl\":$BINPOLL_SOUND_URL}"
echo "$config_data" > "$BINPOLL_FRONT_SRC/src/assets/config.json"


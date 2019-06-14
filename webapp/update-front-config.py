import json
import os

config_data = {}
config_data['apiUrl'] =         os.environ['BINPOLL_API_URL']
config_data['pollSoundsUrl'] =  os.environ['BINPOLL_SOUND_URL'] 
with open(os.environ['BINPOLL_FRONT_SRC'] + "/src/assets/config.json", "w") as f:
    f.write(json.dumps(config_data))


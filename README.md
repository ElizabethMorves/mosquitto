docker build --no-cache -t uzh0r/mosquitto .


docker run -dit --restart=always -d --name=mqtt --hostname=mqtt \
-p 1883:1883 \
-p 8883:8883 \
-p 8083:8083 \
-v /etc/Lets_Encrypt/domain/:/etc/Lets_Encrypt/domain:ro \
-v /mosquitto/mosquitto.conf:/etc/mosquitto/mosquitto.conf:ro \
-v /mosquitto/auth-plugin.conf:/etc/mosquitto.d/auth-plugin.conf:ro \
uzh0r/mosquitto

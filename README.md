mosquitto 1.5.5 - docker
========================

* [MOSQUITTO v1.5.5](https://github.com/eclipse/mosquitto.git)
* [MOSQUITTO_AUTCH_PLUG 0.1.3](https://github.com/jpmens/mosquitto-auth-plug.git)
* [LIBWEBSOCKETS v2.4.2](https://github.com/warmcat/libwebsockets.git)

### build
<pre>
docker build --no-cache -t elizabethmorves/mosquitto .
</pre>

### without ssl
<pre>
docker run -d --restart=unless-stopped \
--name=mqtt \
--hostname=mqtt \
-p 1883:1883 \
-v /mosquitto/mosquitto.conf:/etc/mosquitto/mosquitto.conf:ro \
-v /mosquitto/auth-plugin.conf:/etc/mosquitto.d/auth-plugin.conf:ro \
elizabethmorves/mosquitto
</pre>

### with ssl 
<pre>
docker run -d --restart=unless-stopped \
--name=mqtt \
--hostname=mqtt \
-p 1883:1883 \
-p 8883:8883 \
-p 8083:8083 \
-v /etc/Lets_Encrypt/domain/:/etc/Lets_Encrypt/domain:ro \
-v /mosquitto/mosquitto.conf:/etc/mosquitto/mosquitto.conf:ro \
-v /mosquitto/auth-plugin.conf:/etc/mosquitto.d/auth-plugin.conf:ro \
elizabethmorves/mosquitto
</pre>

### generate password for mysql
<pre>
docker exec -ti mqtt np -p secretpass
PBKDF2$sha256$901$Jr9hFsQLG5P7nqGJ$zGPZniaC8bQu6VahzNl5RiNiafPXHMqU
</pre>

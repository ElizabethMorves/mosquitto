<a href="https://github.com/eclipse/mosquitto.git">MOSQUITTO</a> v1.5.5<br />
<a href="https://github.com/jpmens/mosquitto-auth-plug.git">MOSQUITTO_AUTCH_PLUG</a> 0.1.3<br />
<a href="https://github.com/warmcat/libwebsockets.git">LIBWEBSOCKETS</a> v2.4.2<br />


<pre>
docker build --no-cache -t uzh0r/mosquitto .
</pre>

<pre>
docker run -dit --restart=always -d --name=mqtt --hostname=mqtt \
-p 1883:1883 \
-p 8883:8883 \
-p 8083:8083 \
-v /etc/Lets_Encrypt/domain/:/etc/Lets_Encrypt/domain:ro \
-v /mosquitto/mosquitto.conf:/etc/mosquitto/mosquitto.conf:ro \
-v /mosquitto/auth-plugin.conf:/etc/mosquitto.d/auth-plugin.conf:ro \
uzh0r/mosquitto
</pre>

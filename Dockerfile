FROM alpine:3.8

LABEL maintainer="Elizabeth.Morves <Elizabeth.Morves@gmail.com>"

ENV MOSQUITTO_VERSION=v1.5.5
ENV MOSQUITTO_AUTCH_PLUG_VERSION=0.1.3
ENV LIBWEBSOCKETS_VERSION=v2.4.2

VOLUME ["/var/lib/mosquitto", "/etc/mosquitto", "/etc/mosquitto.d"]

COPY run.sh /

RUN apk update && \
apk --no-cache add \
    openssl \
    build-base \
    libressl-dev \
    c-ares-dev \
    git \
    util-linux-dev \
    cmake \
    libxslt \
    python2 \
    mariadb-connector-c-dev && \
chmod +x /run.sh && \
mkdir /build/ && cd /build && \
git clone -b ${MOSQUITTO_VERSION} https://github.com/eclipse/mosquitto.git && \
git clone -b ${MOSQUITTO_AUTCH_PLUG_VERSION} https://github.com/jpmens/mosquitto-auth-plug.git && \
git clone -b ${LIBWEBSOCKETS_VERSION} https://github.com/warmcat/libwebsockets.git && \
cd /build/libwebsockets && \
    cmake . \
      -DCMAKE_BUILD_TYPE=MinSizeRel \
      -DLWS_IPV6=ON \
      -DLWS_WITHOUT_CLIENT=ON \
      -DLWS_WITHOUT_TESTAPPS=ON \
      -DLWS_WITHOUT_EXTENSIONS=ON \
      -DLWS_WITHOUT_BUILTIN_GETIFADDRS=ON \
      -DLWS_WITH_ZIP_FOPS=OFF \
      -DLWS_WITH_ZLIB=OFF \
      -DLWS_WITH_SHARED=OFF && \
    make -j "$(nproc)" && \
    make install && \
cd /build//mosquitto && \
make -j "$(nproc)" \
    CFLAGS="-Wall -O2 -I/libwebsockets/include" \
    LDFLAGS="-L/libwebsockets/lib" \
    WITH_SRV=yes \
    WITH_ADNS=no \
    WITH_DOCS=no \
    WITH_MEMORY_TRACKING=no \
    WITH_TLS_PSK=no \
    WITH_WEBSOCKETS=yes \
    install && \
cd /build/mosquitto-auth-plug && cp config.mk.in config.mk && \
    sed -i "s/BACKEND_CDB ?= no/BACKEND_CDB ?= no/" config.mk && \
    sed -i "s/BACKEND_MYSQL ?= yes/BACKEND_MYSQL ?= yes/" config.mk && \
    sed -i "s/BACKEND_SQLITE ?= no/BACKEND_SQLITE ?= no/" config.mk && \
    sed -i "s/BACKEND_REDIS ?= no/BACKEND_REDIS ?= no/" config.mk && \
    sed -i "s/BACKEND_POSTGRES ?= no/BACKEND_POSTGRES ?= no/" config.mk && \
    sed -i "s/BACKEND_LDAP ?= no/BACKEND_LDAP ?= no/" config.mk && \
    sed -i "s/BACKEND_HTTP ?= no/BACKEND_HTTP ?= no/" config.mk && \
    sed -i "s/BACKEND_JWT ?= no/BACKEND_JWT ?= no/" config.mk && \
    sed -i "s/BACKEND_MONGO ?= no/BACKEND_MONGO ?= no/" config.mk && \
    sed -i "s/BACKEND_FILES ?= no/BACKEND_FILES ?= no/" config.mk && \
    sed -i "s/BACKEND_MEMCACHED ?= no/BACKEND_MEMCACHED ?= no/" config.mk && \
    sed -i "s/\/\/_log(LOG_DEBUG, \"SQL: %s\", query);/_log(LOG_DEBUG, \"SQL: %s\", query);/" be-mysql.c && \
make -j "$(nproc)" && \
    install -s -m755 auth-plug.so /usr/local/lib/ && \
    install -s -m755 np /usr/local/bin/ && \
cd / && rm -rf /build

RUN addgroup -S mosquitto && \
adduser -S -H -h /var/empty -s /sbin/nologin -D -G mosquitto mosquitto

ENTRYPOINT ["/run.sh"]
CMD ["mosquitto"]


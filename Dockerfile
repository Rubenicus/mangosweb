FROM malfurious/nginx-php

LABEL description="Mangosweb Docker using Nginx + PHP" \
      maintainer="Malfurious <jmay9990@gmail.com>"
RUN echo "@community https://nl.alpinelinux.org/alpine/v3.6/community" >> /etc/apk/repositories \
 && apk -U upgrade

RUN apk add gnupg openssl dovecot tini@community wget \
 && cd /tmp \
 && wget -q https://github.com/Rubenicus/MaNGOSWebV5/archive/master.zip \
 && mkdir /tmp/mangosweb \
 && unzip -q /tmp/master.zip -d /tmp/mangosweb \
 && mv /tmp/mangosweb/MaNGOSWebV5-master /mangosweb \
 && rm -rf /mangosweb/config/config-protected.php /tmp/*

COPY docker/docker-mangosweb/rootfs /
RUN find /mangosweb -type d -exec chmod 755 {} \; \
 && find /mangosweb -type f -exec chmod 644 {} \;

RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

EXPOSE 7788

CMD ["tini", "--", "run.sh"]

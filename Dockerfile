FROM momar/caddy-php

USER 0

RUN apk add --no-cache git php7-tidy php7-fileinfo php7-memcached &&\
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php &&\
    php -r "unlink('composer-setup.php');" &&\
    mv composer.phar /usr/local/bin/composer &&\
    rm Caddyfile && chown 1000:1000 .

USER 1000

RUN git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch .
RUN composer install
ADD Caddyfile /data/
ADD init /init

CMD ["/smell-baron", "-c", "/bin/sh", "/init", \
              "---", "/usr/sbin/php-fpm7", "--allow-to-run-as-root", "--nodaemonize", "--fpm-config", "/etc/php7/php-fpm.conf", \
              "---", "/usr/local/bin/caddy", "-agree=true", "-conf=/data/Caddyfile", "-root=/data", "-log=stdout", "-email=", "-grace=1s"]

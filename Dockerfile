# BUILDS e98cuenc/nginx-php-fpm

FROM alpine:3.5
LABEL maintainer="Joaquin Cuenca Abela <e98cuenc@gmail.com>"

# Install nginx-php-fpm
ADD files /

RUN apk add --no-cache runit nginx memcached php5-cli php5-fpm php5-soap php5-json php5-memcache \
        php5-mysqli php5-openssl php5-gettext php5-ctype php5-xml php5-phar php5-dom php5-curl \
        php5-opcache php5-gd php5-iconv php5-intl mariadb mariadb-client mariadb-dev strace redis inotify-tools gettext make git \
        openssh-client perl bash jq nodejs sphinx curl bind-tools \
        groff less python py-pip g++ gcc libxslt libxslt-dev python-dev && \
    apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv && \
    pip install awscli cssselect requests futures lxml mysql-python youtube-dl && \
    apk --purge -v del py-pip python-dev libxslt-dev mariadb-dev && \
    touch /root/.bashrc && \
    curl -o- -L https://yarnpkg.com/install.sh | bash && \
    curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -o ngrok.zip && \
    unzip ngrok.zip && \
    mv ngrok /usr/bin && \
    rm -f ngrok.zip && \
    rm -rf /var/www/* && \
    mkdir -p /var/run/mysql && \
    chown mysql -R /var/run/mysql /etc/mysql/my.cnf && \
    update-ca-certificates && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql && \
    echo -e "USE mysql;\n\
             REPLACE INTO user VALUES ('%','root','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0,'','','N','N','',0);\n" | \
    mysqld --bootstrap --datadir=/var/lib/mysql --user=mysql && \
    rm -rf \
        /usr/bin/aria_chk \
        /usr/bin/aria_dump_log \
        /usr/bin/aria_ftdump \
        /usr/bin/aria_pack \
        /usr/bin/aria_read_log \
        /usr/bin/innochecksum \
        /usr/bin/my_print_defaults \
        /usr/bin/myisamchk \
        /usr/bin/myisamlog \
        /usr/bin/myisampack \
        /usr/bin/mysql_client_test_embedded \
        /usr/bin/mysql_embedded \
        /usr/bin/mysql_plugin \
        /usr/bin/mysql_tzinfo_to_sql \
        /usr/bin/mysql_upgrade \
        /usr/bin/mysql_waitpid \
        /usr/bin/mysqladmin \
        /usr/bin/mysqlbinlog \
        /usr/bin/mysqlcheck \
        /usr/bin/mysqldump \
        /usr/bin/mysqlimport \
        /usr/bin/mysqlshow \
        /usr/bin/mysqlslap \
        /usr/bin/mysqltest \
        /usr/bin/mysqltest_embedded \
        /usr/bin/perror \
        /usr/bin/replace \
        /usr/bin/resolve_stack_dump \
        /usr/bin/resolveip && \
    mkdir -p /run/nginx /var/run/memcache /data && \
    chown -R memcached /var/run/memcache && \
    addgroup -S apache && \
    adduser -D -S -G apache apache && \
    curl https://raw.githubusercontent.com/madnight/docker-alpine-wkhtmltopdf/master/wkhtmltopdf --output /bin/wkhtmltopdf && \
    chmod +x /bin/wkhtmltopdf && \
    apk add --update --no-cache libgcc libstdc++ libx11 glib libxrender libxext libintl libcrypto1.0 libssl1.0 ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family

RUN ln -s /usr/bin/php /usr/bin/php56

EXPOSE 80 443 3306
VOLUME /var/www
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
ENTRYPOINT ["runsvdir", "/etc/service"]

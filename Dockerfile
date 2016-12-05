# BUILDS e98cuenc/nginx-php-fpm

FROM qlustor/alpine-runit:3.3
MAINTAINER Joaquin Cuenca Abela <e98cuenc@gmail.com>

# Install nginx-php-fpm
ADD files /

RUN apk-install --no-cache --update nginx memcached php-cli php-fpm php-soap php-json php-memcache php-mysqli php-openssl php-gettext php-ctype php-xml php-phar php-dom mariadb strace redis inotify-tools gettext make git openssh-client perl bash && \
    rm -rf /var/www/* && \
    mkdir -p /var/run/mysql && \
    chown mysql -R /var/run/mysql /etc/mysql/my.cnf && \
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
        /usr/bin/mysqlbinlog \
        /usr/bin/mysqlslap \
        /usr/bin/mysqltest \
        /usr/bin/mysqltest_embedded \
        /usr/bin/perror \
        /usr/bin/replace \
        /usr/bin/resolve_stack_dump \
        /usr/bin/resolveip && \
    sed -i -r \
        -e 's/group =.*/group = nginx/' \
        -e 's/user =.*/user = nginx/' \
        -e 's/(; *)?listen\.owner.*/listen\.owner = nginx/' \
        -e 's/(; *)?listen\.group.*/listen\.group = nginx/' \
        -e 's/(; *)?listen\.mode.*/listen\.mode = 0660/' \
        -e 's@(; *)?error_log =.*@error_log = /proc/self/fd/2@' \
        -e 's@(; *)?access\.log =.*@access.log = /proc/self/fd/2@' \
        -e 's@listen =.*@listen = /var/run/php5-fpm.sock@' \
        /etc/php/php-fpm.conf && \
    sed -i \
        -e '/open_basedir =/s/^/\;/' \
        /etc/php/php.ini && \
    mkdir -p /run/nginx && \
    chown -R nginx /run/nginx

EXPOSE 80 443 3306
#VOLUME /var/www
ENTRYPOINT ["/sbin/runit-docker"]


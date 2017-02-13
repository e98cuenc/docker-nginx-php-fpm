# BUILDS e98cuenc/nginx-php-fpm

FROM alpine:3.5
MAINTAINER Joaquin Cuenca Abela <e98cuenc@gmail.com>

# Install nginx-php-fpm
ADD files /

RUN apk add --no-cache runit nginx memcached php5-cli php5-fpm php5-soap php5-json php5-memcache php5-mysqli php5-openssl php5-gettext php5-ctype php5-xml php5-phar php5-dom php5-curl mariadb mariadb-client strace redis inotify-tools gettext make git openssh-client perl bash jq nodejs sphinx && \
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
    mkdir -p /run/nginx /var/run/memcache && \
    chown -R nginx /run/nginx && \
    chown -R memcached /var/run/memcache

EXPOSE 80 443 3306
VOLUME /var/www
ENTRYPOINT ["runsvdir", "/etc/service"]

FROM httpd:2.4

RUN mkdir -p /usr/local/apache2/conf/extra /var/www/locks/ \
    && chown www-data:www-data /var/www/locks/ \
    && echo "ServerTokens Min" >> /usr/local/apache2/conf/httpd.conf \
    && echo "CustomLog /var/log/access.log combined" >> /usr/local/apache2/conf/httpd.conf \
    && echo "ErrorLog /var/log/error.log" >> /usr/local/apache2/conf/httpd.conf \
    && echo "DAVLockDB /var/www/locks/lockdb" >> /usr/local/apache2/conf/httpd.conf \ 
    && echo "Include conf/extra/webdav.conf" >> /usr/local/apache2/conf/httpd.conf \
    && sed -i \
        -e 's/^#\(LoadModule dav_module modules\/mod_dav.so\)/\1/' \
        -e 's/^#\(LoadModule dav_fs_module modules\/mod_dav_fs.so\)/\1/' \
        -e 's/^#\(LoadModule ssl_module modules\/mod_ssl.so\)/\1/' \
        -e 's/^#\(LoadModule remoteip_module modules\/mod_remoteip.so\)/\1/' \
            /usr/local/apache2/conf/httpd.conf \
    && apt-get update \
    && apt-get install -y --no-install-recommends 'gettext-base=0.21-12' \
    && rm -rf /var/lib/apt/lists/*

COPY ./webdav.conf.template /etc/apache2/webdav.conf.template
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 4443

ENTRYPOINT ["/start.sh"]

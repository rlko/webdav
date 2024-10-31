#!/bin/bash

gen_dav_vhost() {
    if [ -z "$SERVER_NAME" ]; then
        echo "Error: SERVER_NAME environment variable is not set."
        exit 1
    fi
    if [ -z "$SERVER_ADMIN" ]; then
        export SERVER_ADMIN="webmaster@localhost"
    fi

    if [ -z "$AUTH_NAME" ]; then
        export AUTH_NAME="Protected Area"
    fi

    envsubst '${SERVER_NAME} ${SERVER_ADMIN} ${AUTH_NAME}' < \
    /etc/apache2/webdav.conf.template > \
    /usr/local/apache2/conf/extra/webdav.conf
}

import_htpasswd_from_env() {
    if ! [ -z "$HTPASSWD" ]; then
        HTPASSWD_FILE="/etc/apache2/webdav.htpasswd"

        echo "$HTPASSWD" > "$HTPASSWD_FILE"
        chown www-data:www-data "$HTPASSWD_FILE"
        chmod 640 "$HTPASSWD_FILE"
    fi
}

gen_ssl() {
    CERT_DIR="/etc/apache2/ssl"
    CERT_FILE="${CERT_DIR}/server.crt"
    KEY_FILE="${CERT_DIR}/server.key"
    
    mkdir -p $CERT_DIR

    # Generate self-signed certificate if it doesn't exist
    if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout "$KEY_FILE" \
            -out "$CERT_FILE" \
            -subj "/CN=${SERVER_NAME}"
    else
        echo "Certificate for $SERVER_NAME already exists. Skipping generation."
    fi
}

main() {
    gen_dav_vhost
    import_htpasswd_from_env
    gen_ssl

    httpd-foreground
}

main

#!/bin/ash

set -e 

app=squid
user=$app


echo "Installing $app and deps ..."
apk --no-cache add curl squid


echo "Installing dumb-init v:$DUMB_INIT_VERSION ..."
curl -sSL -o /dumb-init \
    https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64


echo "Installing gosu v: $GOSU_VERSION ..."
curl -sSL -o /usr/local/bin/gosu \
    https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64


echo "Setting permissions ..."
chown -R $user:$user /etc/squid
chmod +x /dumb-init /usr/local/bin/gosu


echo "Cleaning up ..."
apk del --purge curl

rm -r -- "$0"

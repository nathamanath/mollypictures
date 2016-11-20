#!/bin/bash

# Put certs where nginx can see them

SSL_PATH=/etc/ssl
LE_LIVE_PATH=/etc/letsencrypt/live

cp $LE_LIVE_PATH/$LE_DOMAIN/fullchain.pem $SSL_PATH/
cp $LE_LIVE_PATH/$LE_DOMAIN/privkey.pem $SSL_PATH/

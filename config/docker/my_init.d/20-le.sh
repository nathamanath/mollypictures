#!/bin/bash

# If $LE_EMAIL and $LE_DOMAIN are set, request SSL certificates from lets encrypt

if [ "$LE_EMAIL" ] && [ "$LE_DOMAIN" ]
then

  mkdir -p /data/www

  # Get initial certificates
  certbot certonly -n \
    -w /data/www \
    -d $LE_DOMAIN \
    --email $LE_EMAIL \
    --agree-tos \
    --standalone \
    --preferred-challenges http-01

  # Get rid of this task.. added my own in cron.weekly
  rm /etc/cron.d/certbot

  /etc/docker/bin/copy_certs.sh

fi

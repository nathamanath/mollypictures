#!/bin/bash

# since certificates are only renewed when they’re determined to be near
# expiry, the command can run on a regular basis, like every week or
# every day

certbot renew -q \
  --standalone \
  --preferred-challenges http-01 \
  --pre-hook "sv stop nginx" \
  --post-hook "sv start nginx"

/etc/docker/bin/copy_certs.sh

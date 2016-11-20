#!/bin/bash

# If not already there, generate diffie hellman params

DH_DIR=/etc/ssl/dh
DH_PARAMS=${DH_DIR}/dh_params.pem

if [ ! -f $DH_PARAMS ]
then
  mkdir -p $DH_DIR
  openssl dhparam -out $DH_PARAMS 2048
fi

#!/bin/bash

MY_INIT_PATH=/etc/my_init.d

# run all executables in myinit.d
if [ "$(ls -A $MY_INIT_PATH)" ]
then

  GLOB="$MY_INIT_PATH/*"

  for f in $GLOB
  do
    $f
  done

fi

# start runit
runsvdir -P /etc/service

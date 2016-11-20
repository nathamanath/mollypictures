#!/bin/bash

MY_INIT_PATH=/etc/my_init.d

# run all executables in myinit.d
if [ "$(ls -A $MY_INIT_PATH)" ]
then

  for f in "$MY_INIT_PATH/*"
  do
    $f
  done

fi

# start runit
runsvdir -P /etc/service

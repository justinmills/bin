#! /bin/bash

# Run a command until it exits with a non-zero return code

running=1
while [ $running = 1 ] ; do
  "$@"
  if [ $? -ne 0 ] ; then
      running=0
  fi
done

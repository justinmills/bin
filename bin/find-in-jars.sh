#! /bin/bash

# Find all of the jars in the current dir and look for a string inside them.  Stop when you find one.

if [ $# -lt 2 ] ; then
    >&2 echo "You must pass in 2 args: <dir> <pattern>"
    exit 1
fi
dir=$1
pat=$2

jars="$(find $dir -name '*.jar')"
for jar in $jars ; do
    res="$(jar tf $jar | grep $pat)"
    if [ -n "$res" ] ; then
        echo Found in jar: $jar
    fi
done

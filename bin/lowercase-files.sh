#! /bin/bash

my_root_dir=.

for SRC in `find $my_root_dir -depth`
do
    DST=`dirname "${SRC}"`/`basename "${SRC}" | tr '[A-Z]' '[a-z]'`
    if [ "${SRC}" != "${DST}" ]
    then
        echo "Proceeding with rename from ${SRC} to ${DST}"
        # TODO: this blindly renames things, but the following will only do so if the target doesn't
        # exist. Unfortunately on osx, the default hfs file system is case insensitive, so it fails
        # the -e check and never moves files
        # [ ! -e "${DST}" ] && mv -T "${SRC}" "${DST}" || echo "${SRC} was not renamed because it exists"
        git mv "${SRC}" "${DST}"
    fi
done

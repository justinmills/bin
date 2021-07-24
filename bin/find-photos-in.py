#! /usr/bin/env python3

'''
For two directories, finds all of the images from the former that exist in the latter.

This is done by comparing the hash of the files in the former directory.
'''

import hashlib
import os
import sys

BLOCKSIZE = 65536

dir1 = sys.argv[1]
dir2 = sys.argv[2]

print(f'Reading images from {dir1}')
print(f'Seeing if they exist in {dir2}')

def md5(filename: str) -> str:
    hasher = hashlib.md5()
    with open(filename, 'rb') as afile:
        buf = afile.read(BLOCKSIZE)
        while len(buf) > 0:
            hasher.update(buf)
            buf = afile.read(BLOCKSIZE)
        return hasher.hexdigest()

hash_map = {}
for (dirpath, dirnames, filenames) in os.walk(dir1):
    for filename in filenames:
        path = os.path.join(dirpath, filename)
        hash = md5(path)
        if hash in hash_map:
            raise Exception(f'Unexpected: two files with the same hash: {path} and {hash_map[hash]}')
        hash_map[hash] = path
        # For testing, only read first 10.
        if len(hash_map) == 10:
            break;

print(f'Done building up the source hash, size: {len(hash_map)}')

# Now to check dir2 to see what we find. Only do this while hash_map has valid entries in it. Once
# it's empty, we no longer need to walk the files.
#
# As we go, if we find a match, spit it out (the source/target files) and remove it from the source
# map, adding it to duplcates.

print(f'Looking in {dir2} to see if any of them also exist in {dir1}')
duplicates = []
for (dirpath, dirnames, filenames) in os.walk(dir2):
    for filename in filenames:
        target_path = os.path.join(dirpath, filename)
        target_hash = md5(target_path)
        if target_hash in hash_map:
            source_path = hash_map[hash]
            print(f'Found {source_path} at {target_path}')
            duplicates.append(source_path)
            del hash_map[hash]
            if len(hash_map) == 0:
                print(f'All entries in {dir1} were found in {dir2}')
                sys.exit(0)

#!/bin/bash

list=`ls -l | awk '/^d/ { print $9 }'`

for i in $list; do
    cd $i;
    conky conky -c "./main.rc" &
    cd ..
done

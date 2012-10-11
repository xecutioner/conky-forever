#!/bin/bash

cd conkyrc
for i in *; do
    if [ -d "$i" ]; then
	cd $i;
	conky -c "./main.rc" &
	cd ..
    fi
done

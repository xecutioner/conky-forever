#!/bin/bash

for i in *; do
    if [ -d "$i" ]; then
	cd $i;
	conky conky -c "./main.rc" &
	cd ..
    fi
done

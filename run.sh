#!/bin/bash

cd conkyrc
for i in *; do
    if [ -d "$i" ]; then
	cd $i;
	conky -c "./main.rc" 2> /tmp/conky.elog & 
	cd ..
    fi
done

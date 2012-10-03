#!/bin/bash

for i in *; do
    if [ -d "$i" ]; then
	cd $i;
	conky -qc "./main.rc" &
	cd ..
    fi
done

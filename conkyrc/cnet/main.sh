#!/bin/bash

netstat -npt > /tmp/netstat.conky

function application {
     list=`sed -n 's/.* [0-9]\+\/\(.*\)-\?$/\1/p' /tmp/netstat.conky | sort | uniq -c| sort -rn`
    echo -n $list #| grep / | cut -f2 -d'/' | sort | uniq -c
#    echo $list #| fold -w 45 -s
}

function connection {
    list=`netstat -npt 2> /dev/null | sed '1,2d; s/\:\:1/localhost/g' | awk 'BEGIN { FS = "[: ]+" } $5 < 1024 {print $5}' | uniq -c`
    echo $list
}

case $1 in
	-a|--app) application;;
	-c|--con) connection;;
esac




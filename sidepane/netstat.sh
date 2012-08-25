#!/bin/bash

list=`netstat -npt 2> /dev/null | grep tcp | grep / | grep 'clock-applet' -v | cut -f2 -d'/' | sort -u`
#list=`netstat -npt 2> /dev/null | grep tcp | grep / | cut -f2 -d'/' | sort -u`
echo $list | fold -w 45 -s


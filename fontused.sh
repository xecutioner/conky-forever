#!/bin/bash

grep "\${*font " -R | sed 's/.*${font \(.*\):.*/\1/pg' -n | sort -u

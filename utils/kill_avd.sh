#!/bin/zsh
kill -9 $(ps aux | grep avd | grep -v grep | awk '{ print $2 }')

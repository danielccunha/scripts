#!/bin/bash
kill -9 $(sudo lsof -t -i:$1)
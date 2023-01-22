#!/usr/bin/env bash

set -e
set -x

IP=$1

STATUSCODE=$(curl --silent -I http://${IP}:8000/ | head -n 1|cut -d$' ' -f2)
if [[ $STATUSCODE -ne 200 ]]; then
    #exit 1
    echo "fail"
    # send email
else
    echo "web-app is up"
fi

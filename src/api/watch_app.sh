#!/bin/bash

echo "watching app"
PID=`ps ax | grep -i 'node app.js' | grep 'node ' | grep -v grep | awk '{print $1}' `
echo "PID=$PID"


if [ "$PID" !=  "" ]
then
   echo "node app.js running, nothing to do"
else
   cd /home/alpha/git/3p/express/myapp; ./run_app.sh
fi


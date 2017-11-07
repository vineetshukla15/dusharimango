#!/usr/bin/env bash

#mv nohup.out nohup.out.1
ps ax | grep -i 'node app.js' | grep 'node ' | grep -v grep | awk '{print $1}' | xargs kill -s 9
nohup /home/joez/local/bin/node app.js > app.log  2>&1 < /dev/null &
tail -200 app.log
#tail -200 nohup.out



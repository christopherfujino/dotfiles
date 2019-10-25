#!/bin/bash

if [ "$1" == 'kill' ]; then
  killall -9 iproxy idevicesyslog
  echo 'Killed iproxy & idevicesyslog.'
  exit 0
fi

IPROXIES=$(pgrep iproxy | wc -l)
SYSLOGS=$(pgrep idevicesyslog | wc -l)

echo -e "Count of iproxy processes:\t\t$IPROXIES"
pgrep iproxy
echo -e "Count of idevicesyslog processes:\t$SYSLOGS"
pgrep idevicesyslog

exit 0

#!/bin/sh

/bin/echo -n 'Stopping FanControlDaemon ... '
/usr/bin/killall FanControlDaemon 2>&1 >/dev/null

/bin/echo -n '(Re)Starting FanControlDaemon ... '
/Library/StartupItems/FanControlDaemon/FanControlDaemon start
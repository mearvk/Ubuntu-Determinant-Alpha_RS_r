#!/bin/sh

# this is needed for the CI
dbus-run-session -- /usr/games/gamemode-simulate-game
return $?

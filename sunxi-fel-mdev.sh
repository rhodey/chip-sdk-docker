#!/bin/bash

if [[ $@ == "ver" ]]; then
  command mdev -s && /usr/local/bin/sunxi-fel.orig ver
else
  command /usr/local/bin/sunxi-fel.orig "$@"
fi

#!/usr/bin/env bash

main() {
  percent=$(df -h | grep '/dev/mapper/system-home' | awk '{print $5}')
  echo "~$percent"
}
main


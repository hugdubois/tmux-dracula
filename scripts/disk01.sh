#!/usr/bin/env bash

main() {
  percent=$(df -h | grep '/dev/mapper/system-root' | awk '{print $5}')
  echo "/$percent"
}
main


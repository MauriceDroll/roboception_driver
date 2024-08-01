#!/bin/sh

uid=$(eval "id -u")
gid=$(eval "id -g")

# Mac user:
# uid=1000
# gid=1000

docker build -t roboception_driver/ros:humble .

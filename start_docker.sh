#!/bin/sh
uid=$(eval "id -u")
gid=$(eval "id -g")

# Mac user:
# uid=1000
# gid=1000

docker build --build-arg UID="$uid" --build-arg GID="$gid" -t roboception_driver/ros:foxy .
echo "Run Container"
xhost + local:root

docker run --name roboception_driver --privileged -it -e DISPLAY=$DISPLAY \
-v /dev:/dev --net host --rm --ipc host roboception_driver/ros:foxy

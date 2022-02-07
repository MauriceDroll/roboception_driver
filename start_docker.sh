#!/bin/sh
uid=$(eval "id -u")
gid=$(eval "id -g")
docker build --build-arg UID="$uid" --build-arg GID="$gid" --build-arg ROS_DISTRO=foxy -t roboception_driver/ros:foxy .
echo "Run Container"
xhost + local:root

docker run --name roboception_driver --privileged -it -e DISPLAY=$DISPLAY \
-v /dev:/dev --net host --rm --ipc host roboception_driver/ros:foxy


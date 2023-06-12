#!/bin/sh

echo "Run Container"
xhost + local:root

docker run --name roboception_driver --privileged -it -e DISPLAY=$DISPLAY \
       -v /dev:/dev --net host --rm roboception_driver/ros:foxy

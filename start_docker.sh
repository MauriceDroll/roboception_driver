#!/bin/sh

xhost + local:root

docker run \
       --name roboception_driver \
       --privileged \
       -it \
       -e DISPLAY=$DISPLAY \
       --env-file .env \
       -v /dev:/dev \
       --net host \
       --rm \
       roboception_driver/ros:humble

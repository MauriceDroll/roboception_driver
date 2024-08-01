#!/bin/sh

xhost + local:root

docker run \
       --name roboception_driver \
       --privileged \
       -it \
       -e DISPLAY=$DISPLAY \
       --env-file .env \
       -v $PWD/Test:/home/robot/ros_ws:rw \
       --net host \
       --rm \
       roboception_driver/ros:humble

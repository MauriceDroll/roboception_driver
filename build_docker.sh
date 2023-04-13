#!/bin/sh

chmod a+x start_docker.sh

uid=$(eval "id -u")
gid=$(eval "id -g")
USER=nuc
PASSWORD=petra

# Mac user:
# uid=1000
# gid=1000

echo "$PASSWORD" | sudo -S ifconfig eno1 mtu 9000 up

echo "$PASSWORD" | sudo -S ptpd --masteronly --foreground -i eno1 &

docker build --build-arg UID="$uid" --build-arg GID="$gid" -t roboception_driver/ros:foxy .

echo "Run Container"
xhost + local:root

docker run --name roboception_driver --privileged -it -e DISPLAY=$DISPLAY \
       -v /dev:/dev --net host --rm roboception_driver/ros:foxy

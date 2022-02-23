# Roboception Driver

This is the ROS2 driver for the Roboception rc_visard camera. It is completly running in a docker container and based on the official [rc_genicam_driver_ros2 from roboception](https://github.com/roboception/rc_genicam_driver_ros2).

## How to run

### Linux
Simply build and run the docker container with:
```bash
source start_docker.sh
```

### MacOS
Set `uid=1000` and `gid=1000` in the `start_docker.sh`.
Then build and run the docker container with:
```bash
source start_docker.sh
```

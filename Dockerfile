ARG ROS_DISTRO=foxy
FROM ros:${ROS_DISTRO}-ros-base
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
RUN apt install -y python3-rosdep2 
RUN rosdep update
RUN apt update
RUN apt -y dist-upgrade

RUN apt install python3-colcon-common-extensions python3-vcstool 

# Install dependencies
RUN apt install -y ros-foxy-rc-common-msgs \
    ros-foxy-diagnostic-updater \
    ros-foxy-image-transport \
    ros-foxy-rc-genicam-api

ARG USER=robot
ARG PASSWORD=robot
ARG UID=1000
ARG GID=1000
ARG DOMAIN_ID=0
ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}
RUN groupadd -g "$GID" "$USER"  && \
  useradd -m -u "$UID" -g "$GID" --shell $(which bash) "$USER" -G sudo && \
  echo "$USER:$PASSWORD" | chpasswd && \
  echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudogrp

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
RUN echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> /etc/bash.bashrc
RUN echo "export _colcon_cd_root=~/ros2_install" >> /etc/bash.bashrc
RUN echo "export ROS_DOMAIN_ID=${DOMAIN_ID}" >> /etc/bash.bashrc

USER $USER 
RUN rosdep update

RUN mkdir -p /home/"$USER"/ros_ws/src

# Copy /ros folder in docker ros_ws
COPY /ros/. /home/"$USER"/ros_ws/src

RUN cd /home/"$USER"/ros_ws && . /opt/ros/$ROS_DISTRO/setup.sh && colcon build --symlink-install
RUN echo "source /home/$USER/ros_ws/install/setup.bash" >> /home/$USER/.bashrc

WORKDIR /home/$USER/ros_ws

CMD /bin/bash


##############################################################################
##                                 Base Image                               ##
##############################################################################
ARG ROS_DISTRO=foxy
FROM ros:${ROS_DISTRO}-ros-base
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

##############################################################################
##                                 Global Dependecies                       ##
##############################################################################
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-${ROS_DISTRO}-rc-common-msgs \
    ros-${ROS_DISTRO}-diagnostic-updater \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-rc-genicam-api \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

##############################################################################
##                                 Create User                              ##
##############################################################################
ARG USER=docker
ARG PASSWORD=petra
ARG UID=1000
ARG GID=1000
ARG DOMAIN_ID=8
ENV ROS_DOMAIN_ID=${DOMAIN_ID}
ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}
RUN groupadd -g "$GID" "$USER"  && \
    useradd -m -u "$UID" -g "$GID" --shell $(which bash) "$USER" -G sudo && \
    echo "$USER:$PASSWORD" | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudogrp
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
RUN echo "export ROS_DOMAIN_ID=${DOMAIN_ID}" >> /etc/bash.bashrc

COPY dds_profile.xml /home/$USER
RUN chown $USER:$USER /home/$USER/dds_profile.xml
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/home/$USER/dds_profile.xml

USER $USER 
RUN mkdir -p /home/$USER/ros2_ws/src

##############################################################################
##                                 User Dependecies                         ##
##############################################################################
WORKDIR /home/$USER/ros2_ws/src
RUN git clone --depth 1 https://github.com/roboception/rc_genicam_driver_ros2.git

##############################################################################
##                                 Build ROS and run                        ##
##############################################################################
WORKDIR /home/$USER/ros2_ws
RUN . /opt/ros/$ROS_DISTRO/setup.sh && colcon build --symlink-install
RUN echo "source /home/$USER/ros2_ws/install/setup.bash" >> /home/$USER/.bashrc

RUN sudo sed --in-place --expression \
    '$isource "/home/$USER/ros2_ws/install/setup.bash"' \
    /ros_entrypoint.sh


CMD ["ros2", "run", "rc_genicam_driver", "rc_genicam_driver", "--ros-args", "-p", "ptp_enabled:=true", "-r", "/stereo/left/image_rect_color:=/image", "-r", "/stereo/left/camera_info:=/camera_info"]
# CMD /bin/bash
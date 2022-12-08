# Build development environment
# docker build --tag esp-dev-env .

# Launch development environment
# docker run --device /dev/bus/usb/ --interactive --rm --tty --volume "$(pwd)":/host-volume/ esp-dev-env

# _**NOTE:** In order to utilize DFU and debugging functionality, you must
# install (copy) the `.rules` file related to your debugging probe into the
# `/etc/udev/rules.d` directory of the host machine and restart the host._

# _**NOTE:** The debugging probe must be attached while the container is
# launched in order for it to be accessible from inside the container._

# Define global arguments
ARG DEBIAN_FRONTEND="noninteractive"
ARG UID=1000
ARG USER=maker

# POSIX compatible (Linux/Unix) base image
FROM debian:stable-slim

# Import global arguments
ARG DEBIAN_FRONTEND
ARG UID
ARG USER

# Define local arguments

# Create Non-Root User
RUN ["dash", "-c", "\
    addgroup \
     --gid ${UID} \
     \"${USER}\" \
 && adduser \
     --disabled-password \
     --gecos \"\" \
     --ingroup \"${USER}\" \
     --uid ${UID} \
     \"${USER}\" \
 && usermod \
     --append \
     --groups \"dialout,plugdev\" \
     \"${USER}\" \
"]
ENV PATH="/home/${USER}/.local/bin:${PATH}"

# Step 1. Install Prerequisites
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-setup.html#install-prerequisites
RUN ["dash", "-c", "\
    apt-get update --quiet \
 && apt-get install --assume-yes --no-install-recommends --quiet \
     bison \
     ccache \
     cmake \
     dfu-util \
     flex \
     git \
     gperf \
     libffi-dev \
     libpython2.7 \
     libssl-dev \
     libusb-1.0-0 \
     nano \
     ninja-build \
     python3 \
     python3-pip \
     python3-setuptools \
     python3-venv \
     udev \
     wget \
 && apt-get clean \
 && apt-get purge \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
"]

# Install IDF as non-root user
WORKDIR /home/${USER}/
USER ${USER}

# Step 2. Get ESP-IDF
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html#step-2-get-esp-idf
RUN ["dash", "-c", "\
    mkdir esp \
 && cd esp/ \
 && git clone --recursive https://github.com/espressif/esp-idf.git --branch v5.0 \
"]

# Step 3. Set up the tools
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html#step-3-set-up-the-tools

ENV IDF_TARGET="esp32s3"
RUN ["dash", "-c", "\
    cd ./esp/esp-idf \
 && ./install.sh ${IDF_TARGET} \
"]

# SDRPlay SDRConnect

## Overview

This is an unofficial, containerized version of the SDRPlay [SDRconnect](https://www.sdrplay.com/sdrconnect/) server, built on a Debian base image. Although my first choice was Alpine Linux, I opted for Debian due to compatibility issues with the arm64 architecture on Alpine.

## Supported Architectures

- x86_64 (x64)
- aarch64 (arm64)

## Prerequisites

To allow the container to access the SDRPlay device, you need to grant read/write permissions to USB devices. Without this, you may encounter the following error when running the container:

``` shell
libusb: error [get_usbfs_fd] libusb couldn't open USB device /dev/bus/usb/001/014, errno=13
libusb: error [get_usbfs_fd] libusb requires write access to USB device nodes
```

To fix this, create a custom udev rule to grant the necessary permissions. Run the following command to open a new udev rules file:

``` shell
sudo vi /etc/udev/rules.d/99-sdrplay.rules
```

Add the following line to the file:

``` shell
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1df7", ATTRS{idProduct}=="3000", MODE="0666"
```

After saving the file, reload the udev rules to apply the changes:

``` shell
sudo udevadm control --reload-rules && sudo udevadm trigger
```

This ensures that the new udev rule is applied, allowing your container to access the SDRPlay device.

## How to Use

This guide assumes you are familiar with building, running, and managing Docker containers. Below are some basic guidelines to get you started with the SDRconnect container.

### Display help information

To view the available options and usage instructions for the SDRconnect container, run the following command:

``` shell
docker run --rm -it local/sdrconnect --help
```

### Run with basic configuration

At a minimum, you need to provide the container with access to your SDRPlay device and map a port to allow access to the service. Here's an example:

``` shell
docker run --rm -it \
  --name sdrconnect \
  --device /dev/bus/usb:/dev/bus/usb \
  -p 50000:50000 \
  local/sdrconnect:latest
```

### Define additional parameters

You can further customize the SDRconnect container by adding additional parameters. For example, the following command restricts access to a single client and runs the container in exclusive mode (prevent any client from accessing the hardware controls):

``` shell
docker run --rm -it \
  --name sdrconnect \
  --device /dev/bus/usb:/dev/bus/usb \
  -p 50000:50000 \
  local/sdrconnect:latest \
  --exclusive \
  --max-clients=1
```

## Notes

While writing this documentation, I discovered an alternative project on GitHub that essentially accomplishes the same goals as this repository. Although there are some differences in implementation, the final product should provide a similar experience.

You can check out that project over here: [dgadams/sdr-connect](https://github.com/dgadams/sdr-connect)

## References

- [SDRconnect | Official website](https://www.sdrplay.com/sdrconnect/)
- [dgadams/sdr-connect | Alternative project](https://github.com/dgadams/sdr-connect)

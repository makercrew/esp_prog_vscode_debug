# ESP-Prog Debugging in VSCode Sample Repo

This is an example repository to quickly get you debugging and ESP32-based dev board with the ESP-Prog programmer in VSCode.

## Features
Includes VSCode tasks out of the box for:
  - Building firmware
  - Flashing firmware to your device
  - Starting a debug session
  - Monitoring your device over serial
  - Cleaning your build folder

## How To Use This Repo

### New Project

If you are starting a new project from scratch you can clone this repo directly and use it as a bare bones base to build on top of. After cloning, follow the instructions under the **Configuration** section below. 

### Add To Existing Project

If you already have an existing ESP32 firmware project setup in VSCode it is very simple to integrate pieces of this repository into your project. The core functionality to enable debugging is provided by 3 files in the **.vscode** folder.

  - **launch.json** - Contains the debug configuration
  - **settings.json** - Contains environment specific paths to various tools required for building and debugging
  - **tasks.json** - Defines various tasks for building, flashing, monitoring, and debugging

If you don't have any of these files in your existing repo simply copy all of them into your **.vscode** folder. If you have a **launch.json** file I highly recommend you simply replace it with the file in this repo.

If you already have a tasks and settings file you can simply add the contents from the corresponding files in this repo to yours.

## Setup
### Clone the ESP-IDF Repo
If you don't already have it you will need to clone the ESP-IDF repo to a location of your choice on your machine. You will need the path to this location later on.

```sh
git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
git checkout v4.2
```

### Install the ESP-IDF Toolchain
The configuration instructions below assume you have already installed the ESP-IDF toolchain. Instructions for installing the toolchain can be found here.

[Set Up The Tools](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html#step-3-set-up-the-tools)

### Python 2 Dependencies
Due to [some issues with Python versions in the ESP-IDF tooling](https://github.com/espressif/esp-idf/issues/5284#issuecomment-693426699) you must have the Python 2.7 dev dependencies installed on your machine even if you have configured ESP-IDF to use Python 3. You can accomplish this with the following command.

```sh
sudo apt-get install libpython2.7-dev 
```

## Configuration
To configure the tasks and debug configuration there are a few tweaks you need to make to the files in the **.vscode** directory as follows.

### settings.json

  - Replace all instances of **[ESP_IDF_ROOT]** with the fully qualified path of where you cloned the ESP-IDF repo. For example _/home/username/dev/esp-idf_.
  - Replace all instances of **[ESP_TOOLCHAIN_ROOT]** with the fully qualified path of the top level directory containing the ESP-IDF toolchain. On linux this defaults to _/home/[your username]/.espressif_.
  - **esp_device_port** - The path to your device when it's attached via USB. Defaults to _/dev/ttyUSB0_.
  - **esp_device_baud** - The serial baud rate to communicate with your device. Defaults to _115200_.

### launch.json

If you cloned this repository directly to start a new project this file does not need to be changed. Proceed to the next section.

If you added this file to an existing project you need to change the **target** attribute to point to the elf file created during a firmware build. It will be named based on what you call your project in the top-level CMAkeLists.txt file.

### tasks.json

No changes need to be made to this file.

## Debugging Instructions

{% note %}

**Note:** One thing I encountered was that both the ESP32 target device as well as the ESP-Prog will enumerate as `/dev/ttyUSB0` if plugged in first on Linux. Since the debug commands rely on the target device port being constant it's important that you plug in the target device first if you've configured **settings.json** to use `/dev/ttyUSB0` as the flash and monitor port. 

{% endnote %}

  1. Attach the ESP-Prog to your target device via whatever JTAG cable is required.
  1. Plug the target device (the one you want to debug) into your computer.
  1. Press **Ctrl-Alt-T** to launch the Task list in VSCode and select _Flash and Monitor Device_.
  1. The device should successfully flash and start showing serial output if applicable.
  1. Plug the ESP-Prog into your computer. The red LED should illuminate.
  1. Start a debug session with **F5** or **Run->Start Debugging** from the menu.

### Done 🤩
From this state you can makes changes and flash new firmware. Starting a new debug session will reset and halt your device at your application entry point.

{% note %}

**Remember to Flash:** Starting a debug session, unlike in a normal software environment doesn't automatically update the code under debug. Anytime you make changes to your code remember to flash the device again before starting a debug session.

{% endnote %}

### It Stopped Working, Now What? 😞
While I've found this to be a very reliable approach to debugging my ESP32 device occasionally things will stop working and it won't be clear why. The 'ol "turn it off and back on again" is pretty effective here. To fix almost any issues:

  1. Make sure the debugger is stopped by hitting the Red square from the debug panel, hitting **Shift-F5** or **Run->Stop Debugging** from the menu.
  1. Stop OpenOCD by focusing the OpenOCD shell output window and hitting **Ctrl-C**.
  1. Try to start debugging again.

If you get the following error when trying to flash your device:

```sh
A fatal error occurred: Timed out waiting for packet content
CMake Error at run_cmd.cmake:14 (message):
  esptool.py failed
Call Stack (most recent call first):
  run_esptool.cmake:21 (include)
```

This is likely due to the fact that your target device is not at the `/dev/ttyXXX` path you have set in **settings.json**. See the note above about plug-in order. Another thing to try is to disconnect your ESP-Prog and try to flash your device. After successful flash you can reconnect the ESP-Prog to your computer.


## **-----> A Note on Versions <-----**
The main branch of this repo is configured to work with version 4.2 of ESP-IDF. If you are using a different version of IDF it is very likely that paths in the **settings.json** file will need to be altered to match the various toolchain versions.

## Donate a Burrito
This information is the result of hours upon hours of research and trial and error and is provided free to the community to hopefully help other ESP32 makers. That said, if you found this helpful or if it saved you time and you wanna say thanks in the form of a burrito, well, I'm not gonna stop you.

[Buy Me a Burrito](https://www.buymeacoffee.com/kevinsidwar) 🌯🌯🌯
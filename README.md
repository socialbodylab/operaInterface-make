# Costume Lighting Controls

## Installation

The installation has 2 main components

- The Controller Application

    For the Controller Application, you can either use the compiled Release or work directly with the Processing code.

- The Hardware Receiver

    For the Hardware Receiver, you must download the arduino code and upload it to the board


### Control Application

#### Using the Release Build
1. Install the current OpenJDK version for your system
    - Download OpenJDK for [Windows](https://adoptium.net/temurin/releases/?os=windows&arch=x64&package=jdk)
    - Download OpenJDK for [MacOS](https://adoptium.net/temurin/releases/?os=mac&arch=aarch64&package=jdk)
2. Download the the appropriate release for your system
3. Unzip the folder and run the application

#### Running from Processing
1. Install the latest version of Processing
2. Clone or Download the Repo
3. Install the Required Libraries
   - ControlP5
   - ArtNet for Java and Processing 
 
### Hardware Receiver
1. Install the latest version of the Arduino IDE
2. Either Clone/Download the Repo or the Release
3. Install the Board Package
    - ESP32
4. Install the Required Libraries
    - Adafruit NeoPixel
    - ArtnetWifi


## Setup
- Determine the IP address of your computer & range of your network
- Update the WiFi and IP info in the Arduino Code


### Get Network IP Info
1. Connect your computer to your Wifi Network 
2. Open the costumeLight_controls application or run the Processing code
3. Determine the IP Address of your computer from the **Controller IP:** data in the top right corner

<img src="images/ControllerIP.png" alt="Controller IP Display" width="800">

In this example our Controller IP is **192.168.1.2**, but this will be different for each computer/network

4. From our Device IP Address we can determine important data that we will need for the Arduino code

### Update the Arduino Code
1. Open the Arduino file: costumeLight_receiver.ino
2. In the Arduino IDE, goto the tab WifiSettings.h and update the code to match your local network
```arduino
// WiFi network credentials
// Change these to match your WiFi network
const char* WIFI_SSID = "myHomeNetwork";           // The name of your WiFi network
const char* WIFI_PASSWORD = "blinkylights";        // Your WiFi password

// Fixed IP address configuration
// Change these if they conflict with your network setup
IPAddress LOCAL_IP(192, 168, 1, 100);   // Static IP address for the ESP32
IPAddress GATEWAY(192, 168, 1, 1);     // Gateway (usually your router's IP)
IPAddress SUBNET(255, 255, 255, 0);      // Subnet mask  

// Art-Net specific settings
const int UNIVERSE = 0;                  // Art-Net universe to listen on *No need to update*
```
#### To determine the **LOCAL_IP** and **GATEWAY**
1. Use the IP address of the controller as the staring point. In our case it is: **192.168.1.2**



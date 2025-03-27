// ArtNetDevice.pde
// Class to manage ArtNet communication with LED hardware

import ch.bildspur.artnet.*;

class ArtNetDevice {
  ArtNetClient artnet;
  int universe;
  String deviceIP;
  boolean connected = false;
  
  // Buffer for combined data (badge + collar)
  byte[] combinedData;
  
  ArtNetDevice(int universe, String deviceIP, int totalLEDs) {
    this.universe = universe;
    this.deviceIP = deviceIP;
    
    // Initialize the byte array to hold RGB data for all LEDs
    combinedData = new byte[totalLEDs * 3];
    
    // Initialize ArtNet client
    try {
      artnet = new ArtNetClient(null);
      artnet.start();
      connected = true;
      println("ArtNet client initialized. Sending to " + deviceIP + " on universe " + universe);
    } catch (Exception e) {
      println("Error initializing ArtNet client: " + e.getMessage());
      connected = false;
    }
  }
  
  // Update the data buffer with grid (badge) and strip (collar) LED colors
  void updateData(LED[][] gridLEDs, LED[] stripLEDs) {
    int index = 0;
    
    // First copy badge (grid) data - assuming 8x4 = 32 LEDs
    for (int y = 0; y < gridLEDs.length; y++) {
      for (int x = 0; x < gridLEDs[y].length; x++) {
        color c = gridLEDs[y][x].currentColor;
        
        // R, G, B values
        combinedData[index++] = (byte)((c >> 16) & 0xFF);  // Red
        combinedData[index++] = (byte)((c >> 8) & 0xFF);   // Green
        combinedData[index++] = (byte)(c & 0xFF);          // Blue
      }
    }
    
    // Then copy collar (strip) data
    for (int i = 0; i < stripLEDs.length; i++) {
      color c = stripLEDs[i].currentColor;
      
      // R, G, B values
      combinedData[index++] = (byte)((c >> 16) & 0xFF);  // Red
      combinedData[index++] = (byte)((c >> 8) & 0xFF);   // Green
      combinedData[index++] = (byte)(c & 0xFF);          // Blue
    }
  }
  
  // Send the data via ArtNet
  void sendData() {
    if (connected) {
      try {
        artnet.unicastDmx(deviceIP, universe, 0, combinedData);
      } catch (Exception e) {
        println("Error sending ArtNet data: " + e.getMessage());
      }
    }
  }
  
  // Close the ArtNet client properly
  void stop() {
    if (artnet != null) {
      artnet.stop();
    }
  }
}

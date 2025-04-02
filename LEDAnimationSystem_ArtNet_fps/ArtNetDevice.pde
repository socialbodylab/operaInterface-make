import ch.bildspur.artnet.*;

class ArtNetDevice {
  ArtNetClient artnet;
  int universe;
  String deviceIP;
  boolean connected = false;
  
  // Buffer for combined data (badge + collar)
  byte[] combinedData;
  
  // First byte is reserved for brightness (added to the beginning of the data array)
  byte brightnessValue = 50; // Default brightness
  
  ArtNetDevice(int universe, String deviceIP, int totalLEDs) {
    this.universe = universe;
    this.deviceIP = deviceIP;
    
    // Initialize the byte array to hold brightness byte + RGB data for all LEDs
    // Add 1 for the brightness byte
    combinedData = new byte[1 + totalLEDs * 3];
    
    // Set default brightness
    combinedData[0] = brightnessValue;
    
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
  
  // Update the data buffer with grid (badge) and strip (collar) LED colors and the brightness value
  void updateData(LED[][] gridLEDs, LED[] stripLEDs, int brightness) {
    // Set brightness byte (first byte of the data)
    brightnessValue = (byte)brightness;
    combinedData[0] = brightnessValue;
    
    // Start index after brightness byte
    int index = 1;
    
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

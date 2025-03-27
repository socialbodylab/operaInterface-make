import controlP5.*;
import ch.bildspur.artnet.*;

// Global variables
ControlP5 cp5;
Grid ledGrid;
Strip ledStrip;
boolean initialized = false;

// Animation timer to track elapsed time for animations
long startTime;

// Currently selected effects and playback modes
String gridEffect = "pulse";
String stripEffect = "pulse";
String gridPlayback = "loop";
String stripPlayback = "loop";

// Current colors
color gridStartColor = #FF00FF; // Default magenta
color gridEndColor = #00FFFF;   // Default cyan
color stripStartColor = #FF0000; // Default red
color stripEndColor = #0000FF;   // Default blue

// Speed values
float gridSpeed = 1.0;
float stripSpeed = 0.5;

// Strip LED count
int stripCount = 72;

// Linear fade angle for grid
float gridLinearAngle = 0;

// ArtNet settings
ArtNetDevice artnetDevice;
String deviceIP = "192.168.137.10";  // Default IP address from the Arduino code
int universe = 0;                    // Default universe from the Arduino code
boolean artNetEnabled = true;        // Enable/disable ArtNet sending

// Frame timing
int lastFrameTime = 0;
int frameInterval = 25;  // ~40fps max for ArtNet updates

void setup() {
  size(1300, 1100);
  background(245);
  
  // Initialize UI
  cp5 = new ControlP5(this);
  
  // Initialize LEDs
  ledGrid = new Grid(8, 4);
  ledStrip = new Strip(stripCount);
  
  // Initialize UI controls
  setupControls();
  
  // Apply styling to color wheels
  fixColorWheelStyling();
  
  // Initialize animation timer
  startTime = millis();
  
  // Initialize ArtNet device (badge = 32 LEDs, collar = 72 LEDs = 104 total)
  if (artNetEnabled) {
    try {
      artnetDevice = new ArtNetDevice(universe, deviceIP, 32 + stripCount);
      println("ArtNet initialized: " + deviceIP + " on universe " + universe);
    } catch (Exception e) {
      println("Error initializing ArtNet: " + e.getMessage());
      artNetEnabled = false;
    }
  }
  
  initialized = true;
}

void draw() {
  // Frame rate limiting for ArtNet
  int currentTime = millis();
  if (artNetEnabled && currentTime - lastFrameTime < frameInterval) {
    return;
  }
  lastFrameTime = currentTime;
  
  background(245);
  
  // Draw main container
  fill(255);
  stroke(0, 0, 0, 25);
  rect(20, 20, width-40, height-40, 8);
  
  // Update animations
  if (initialized) {
    // Update color values from the ColorWheels
    updateColorsFromWheels();
    
    ledGrid.update();
    ledStrip.update();
    
    // Draw the LED grid and strip
    ledGrid.display();
    ledStrip.display();
    
    // Send the LED data via ArtNet
    if (artNetEnabled && artnetDevice != null) {
      artnetDevice.updateData(ledGrid.leds, ledStrip.leds);
      artnetDevice.sendData();
    }
  }
}

// Reset the animation timer
void resetAnimations() {
  startTime = millis();
  ledGrid.resetColors();
  ledStrip.resetColors();
}

// Update color values from ColorWheel components
void updateColorsFromWheels() {
  // Get ColorWheels from ControlP5
  ColorWheel gridStartWheel = (ColorWheel) cp5.getController("gridStartColorWheel");
  ColorWheel gridEndWheel = (ColorWheel) cp5.getController("gridEndColorWheel");
  ColorWheel stripStartWheel = (ColorWheel) cp5.getController("stripStartColorWheel");
  ColorWheel stripEndWheel = (ColorWheel) cp5.getController("stripEndColorWheel");
  
  // Update color values if wheels are available
  if (gridStartWheel != null) {
    gridStartColor = gridStartWheel.getRGB();
  }
  
  if (gridEndWheel != null) {
    gridEndColor = gridEndWheel.getRGB();
  }
  
  if (stripStartWheel != null) {
    stripStartColor = stripStartWheel.getRGB();
  }
  
  if (stripEndWheel != null) {
    stripEndColor = stripEndWheel.getRGB();
  }
}

// Fix the styling of the ColorWheel components
void fixColorWheelStyling() {
  // This function is now a placeholder since we're letting the ColorWheel handle its own layout
}

// Event handlers for controls
void controlEvent(ControlEvent event) {
  // Handle UI events
  if (!event.isController()) return;
  
  String name = event.getController().getName();
  
  // Grid effect changed
  if (name.equals("gridEffect")) {
    gridEffect = cp5.get(ScrollableList.class, "gridEffect").getItem((int)event.getValue()).get("name").toString();
    resetAnimations();
  }
  // Grid playback changed
  else if (name.equals("gridPlayback")) {
    gridPlayback = cp5.get(ScrollableList.class, "gridPlayback").getItem((int)event.getValue()).get("name").toString();
    resetAnimations();
  }
  // Strip effect changed
  else if (name.equals("stripEffect")) {
    stripEffect = cp5.get(ScrollableList.class, "stripEffect").getItem((int)event.getValue()).get("name").toString();
    resetAnimations();
  }
  // Strip playback changed
  else if (name.equals("stripPlayback")) {
    stripPlayback = cp5.get(ScrollableList.class, "stripPlayback").getItem((int)event.getValue()).get("name").toString();
    resetAnimations();
  }
  // Strip count changed
  else if (name.equals("stripCount")) {
    stripCount = int(event.getController().getValue());
    ledStrip = new Strip(stripCount);
    // Recreate ArtNet device with new LED count
    if (artNetEnabled) {
      connectArtNet();
    }
  }
  // Grid speed changed
  else if (name.equals("gridSpeed")) {
    gridSpeed = event.getController().getValue();
  }
  // Strip speed changed
  else if (name.equals("stripSpeed")) {
    stripSpeed = event.getController().getValue();
  }
  // Grid linear angle changed
  else if (name.equals("gridLinearAngle")) {
    gridLinearAngle = event.getController().getValue();
  }
  // ArtNet enabled toggle changed
  else if (name.equals("artNetEnabled")) {
    artNetEnabled = event.getController().getValue() > 0.5;
    updateArtNetStatus();
  }
  // Device IP changed
  else if (name.equals("deviceIP")) {
    deviceIP = cp5.get(Textfield.class, "deviceIP").getText();
  }
  // Universe changed
  else if (name.equals("universe")) {
    universe = int(event.getController().getValue());
  }
  // Connect button pressed
  else if (name.equals("connectArtNet")) {
    connectArtNet();
  }
}

// ArtNet connection methods
void connectArtNet() {
  // Clean up existing connection if any
  if (artnetDevice != null) {
    artnetDevice.stop();
    artnetDevice = null;
  }
  
  if (artNetEnabled) {
    try {
      // Create a new ArtNet device with current settings
      artnetDevice = new ArtNetDevice(universe, deviceIP, 32 + stripCount);
      updateArtNetStatus();
    } catch (Exception e) {
      println("Error connecting to ArtNet: " + e.getMessage());
      Textlabel statusLabel = cp5.get(Textlabel.class, "artnetStatus");
      if (statusLabel != null) {
        statusLabel.setText("Status: Error - " + e.getMessage());
      }
    }
  }
}

void updateArtNetStatus() {
  Textlabel statusLabel = cp5.get(Textlabel.class, "artnetStatus");
  if (statusLabel == null) return;
  
  String status = "Status: ";
  
  if (!artNetEnabled) {
    status += "Disabled";
  } else if (artnetDevice != null && artnetDevice.connected) {
    status += "Connected to " + deviceIP + " on universe " + universe;
  } else {
    status += "Not Connected";
  }
  
  statusLabel.setText(status);
}

// Clean shutdown - important for ArtNet
void exit() {
  if (artnetDevice != null) {
    artnetDevice.stop();
  }
  super.exit();
}

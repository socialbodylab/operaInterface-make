// Controls.pde
// Functions for setting up and managing UI controls

void setupControls() {
  // Calculate total height needed for LEDs to position controls below
  float ledsHeight = ledGrid.yPos + ledGrid.height + 10; // Reduced spacing after grid
  
  // Add space for the LED strip (account for multiple rows)
  int maxLedsPerRow = (int) Math.floor((windowWidth - 100) / (ledStrip.ledSize + ledStrip.spacing));
  int rowCount = (int) Math.ceil((float)stripCount / maxLedsPerRow);
  float stripHeight = rowCount * (ledStrip.ledSize + ledStrip.spacing) + 10;
  
  // Position controls directly after the strip with minimal spacing
  float controlsY = ledStrip.yPos + stripHeight + 30; // Minimize space after strip
  
  // Create groups for grid and strip controls with proper spacing
  setupGridControlGroup(controlsY);
  setupStripControlGroup(controlsY);
  
  // Create group for ArtNet settings - minimal distance from Grid/Strip controls
  setupArtNetControlGroup(controlsY + 450); // Position ArtNet group closer to previous controls
}

void setupGridControlGroup(float yPos) {
  // Adjusted width to fit within narrower window with 5px margin
  int groupWidth = (windowWidth - 40) / 2 - 10;
  
  // Create a group for grid controls
  Group gridGroup = cp5.addGroup("Grid Controls")
    .setPosition(20, yPos)  // Left side, adjusted for narrower window
    .setWidth(groupWidth)
    .setBackgroundHeight(400) // Slightly reduced height for better fit
    .setBackgroundColor(color(240))
    .setBarHeight(25)
    .setColorBackground(color(60, 60, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    .disableCollapse()
    ;
    
  // Keep original wheel size
  int wheelSize = int(groupWidth * 0.4);
  
  // Original positions, just closer to top
  cp5.addColorWheel("gridStartColorWheel")
    .setPosition(30, 35) // Only slightly reduced top margin
    .setSize(wheelSize, wheelSize)
    .setRGB(gridStartColor)
    .setLabel("START COLOR")
    .setGroup(gridGroup)
    ;
    
  // End color wheel
  cp5.addColorWheel("gridEndColorWheel")
    .setPosition(wheelSize + 70, 35) // Only slightly reduced top margin
    .setSize(wheelSize, wheelSize)
    .setRGB(gridEndColor)
    .setLabel("END COLOR")
    .setGroup(gridGroup)
    ;
  
  int controlWidth = groupWidth - 40;
  int controlHalfWidth = (controlWidth - 20) / 2;
  
  // Reduced spacing between color wheels and controls below
  cp5.addScrollableList("gridEffect")
    .setPosition(20, wheelSize + 45) // Reduced margin after wheels
    .setSize(controlHalfWidth, 140)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("none", "solid", "pulse", "linear", "constrainbow", "rainbow", "wipe"))
    .setValue(2) // Default to pulse (index 2)
    .setLabel("EFFECT")
    .setGroup(gridGroup)
    ;
  
  // Linear fade angle slider - original size
  cp5.addSlider("gridLinearAngle")
    .setPosition(controlHalfWidth + 40, wheelSize + 45) // Reduced margin after wheels
    .setSize(controlHalfWidth, 20)
    .setRange(0, 360)
    .setValue(0)
    .setLabel("LINEAR FADE ANGLE")
    .setGroup(gridGroup)
    ;
  
  // Speed slider - reduced spacing from above control
  cp5.addSlider("gridSpeed")
    .setPosition(controlHalfWidth + 40, wheelSize + 85) // Reduced spacing between controls
    .setSize(controlHalfWidth, 20)
    .setRange(0.1, 10)
    .setValue(1)
    .setLabel("SPEED")
    .setGroup(gridGroup)
    ;
  
  // Playback mode dropdown - reduced spacing from above control
  cp5.addScrollableList("gridPlayback")
    .setPosition(controlHalfWidth + 40, wheelSize + 125) // Reduced spacing between controls
    .setSize(controlHalfWidth, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("loop", "boomerang", "once"))
    .setValue(0) // Default to loop
    .setLabel("PLAYBACK MODE")
    .setGroup(gridGroup)
    ;
}

void setupStripControlGroup(float yPos) {
  // Adjusted width to fit within narrower window with 5px margin
  int groupWidth = (windowWidth - 40) / 2 - 10;
  
  // Create a group for strip controls
  Group stripGroup = cp5.addGroup("Strip Controls")
    .setPosition(windowWidth/2, yPos)  // Right side, adjusted for narrower window
    .setWidth(groupWidth) 
    .setBackgroundHeight(400) // Slightly reduced height for better fit
    .setBackgroundColor(color(240))
    .setBarHeight(25)
    .setColorBackground(color(100, 60, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    .disableCollapse()
    ;
    
  // Keep original wheel size
  int wheelSize = int(groupWidth * 0.4);
  
  // Original positions, just closer to top
  cp5.addColorWheel("stripStartColorWheel")
    .setPosition(30, 35) // Only slightly reduced top margin
    .setSize(wheelSize, wheelSize)
    .setRGB(stripStartColor)
    .setLabel("START COLOR")
    .setGroup(stripGroup)
    ;
    
  // End color wheel
  cp5.addColorWheel("stripEndColorWheel")
    .setPosition(wheelSize + 70, 35) // Only slightly reduced top margin
    .setSize(wheelSize, wheelSize)
    .setRGB(stripEndColor)
    .setLabel("END COLOR")
    .setGroup(stripGroup)
    ;
  
  int controlWidth = groupWidth - 40;
  int controlHalfWidth = (controlWidth - 20) / 2;
  
  // Reduced spacing between color wheels and controls below
  cp5.addScrollableList("stripEffect")
    .setPosition(20, wheelSize + 45) // Reduced margin after wheels
    .setSize(controlHalfWidth, 140)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("none", "solid", "pulse", "linear", "constrainbow", "rainbow", "wipe"))
    .setValue(2) // Default to pulse (index 2)
    .setLabel("EFFECT")
    .setGroup(stripGroup)
    ;
  
  // LED count input - reduced spacing from wheels
  cp5.addNumberbox("stripCount")
    .setPosition(controlHalfWidth + 40, wheelSize + 45) // Reduced margin after wheels
    .setSize(controlHalfWidth, 20)
    .setRange(1, 300)
    .setValue(stripCount)
    .setMultiplier(1)
    .setDirection(Controller.HORIZONTAL)
    .setLabel("NUMBER OF LEDS")
    .setGroup(stripGroup)
    ;
  
  // Speed slider - reduced spacing from above control
  cp5.addSlider("stripSpeed")
    .setPosition(controlHalfWidth + 40, wheelSize + 85) // Reduced spacing between controls
    .setSize(controlHalfWidth, 20)
    .setRange(0.1, 10)
    .setValue(0.5)
    .setLabel("SPEED")
    .setGroup(stripGroup)
    ;
  
  // Playback mode dropdown - reduced spacing from above control
  cp5.addScrollableList("stripPlayback")
    .setPosition(controlHalfWidth + 40, wheelSize + 125) // Reduced spacing between controls
    .setSize(controlHalfWidth, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("loop", "boomerang", "once"))
    .setValue(0) // Default to loop
    .setLabel("PLAYBACK MODE")
    .setGroup(stripGroup)
    ;
}

// Add ArtNet settings group
void setupArtNetControlGroup(float yPos) {
  // Create a group for ArtNet controls
  Group artnetGroup = cp5.addGroup("ArtNet Settings")
    .setPosition(windowWidth/2 - 250, yPos) // Center horizontally
    .setWidth(500)
    .setBackgroundHeight(160) // Original height, fits all controls
    .setBackgroundColor(color(240))
    .setBarHeight(25)
    .setColorBackground(color(80, 80, 120))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    .disableCollapse()
    ;
    
  // Toggle for ArtNet enable/disable - reduced vertical spacing
  cp5.addToggle("artNetEnabled")
     .setPosition(20, 30) // Reduced top margin
     .setSize(50, 20)
     .setValue(artNetEnabled)
     .setLabel("ENABLE ARTNET")
     .setGroup(artnetGroup)
     ;
  
  // Input field for device IP address - reduced vertical spacing
  cp5.addTextfield("deviceIP")
     .setPosition(100, 30) // Reduced top margin
     .setSize(150, 30)
     .setText(deviceIP)
     .setLabel("DEVICE IP")
     .setGroup(artnetGroup)
     .setAutoClear(false)
     ;
     
  // Input field for universe - reduced vertical spacing
  cp5.addNumberbox("universe")
     .setPosition(280, 30) // Reduced top margin
     .setSize(100, 30)
     .setValue(universe)
     .setMultiplier(1)
     .setDirection(Controller.HORIZONTAL)
     .setLabel("UNIVERSE")
     .setGroup(artnetGroup)
     ;
     
  // Connect button - reduced vertical spacing
  cp5.addButton("connectArtNet")
     .setPosition(400, 30) // Reduced top margin
     .setSize(80, 30)
     .setLabel("CONNECT")
     .setGroup(artnetGroup)
     ;
  
  // Reduced spacing between controls
  // FPS control slider
  cp5.addSlider("targetFPS")
     .setPosition(20, 70) // Reduced spacing between controls
     .setSize(350, 20)
     .setRange(1, 60)
     .setValue(targetFPS)
     .setNumberOfTickMarks(12)
     .setLabel("TARGET FPS")
     .setGroup(artnetGroup)
     ;
     
  // Brightness slider - reduced spacing
  cp5.addSlider("ledBrightness")
     .setPosition(20, 100) // Reduced spacing between controls
     .setSize(350, 20)
     .setRange(0, 255)
     .setValue(ledBrightness)
     .setLabel("LED BRIGHTNESS")
     .setGroup(artnetGroup)
     ;
     
  // Status text - reduced spacing
  cp5.addTextlabel("artnetStatus")
     .setPosition(20, 130) // Reduced spacing between controls
     .setText("Status: " + (artNetEnabled ? "Enabled" : "Disabled"))
     .setGroup(artnetGroup)
     ;
}

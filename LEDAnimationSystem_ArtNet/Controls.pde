// Add ArtNet settings group
void setupArtNetControlGroup(float yPos) {
  // Create a group for ArtNet controls
  Group artnetGroup = cp5.addGroup("ArtNet Settings")
    .setPosition(390, yPos + 490) // Position below other controls
    .setWidth(500)
    .setBackgroundHeight(140) // Shorter than other groups
    .setBackgroundColor(color(240))
    .setBarHeight(25)
    .setColorBackground(color(80, 80, 120))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    .disableCollapse()
    ;
    
  // Toggle for ArtNet enable/disable
  cp5.addToggle("artNetEnabled")
     .setPosition(20, 40)
     .setSize(50, 20)
     .setValue(artNetEnabled)
     .setLabel("ENABLE ARTNET")
     .setGroup(artnetGroup)
     ;
  
  // Input field for device IP address
  cp5.addTextfield("deviceIP")
     .setPosition(100, 40)
     .setSize(150, 30)
     .setText(deviceIP)
     .setLabel("DEVICE IP")
     .setGroup(artnetGroup)
     .setAutoClear(false)
     ;
     
  // Input field for universe
  cp5.addNumberbox("universe")
     .setPosition(280, 40)
     .setSize(100, 30)
     .setValue(universe)
     .setMultiplier(1)
     .setDirection(Controller.HORIZONTAL)
     .setLabel("UNIVERSE")
     .setGroup(artnetGroup)
     ;
     
  // Connect button
  cp5.addButton("connectArtNet")
     .setPosition(400, 40)
     .setSize(80, 30)
     .setLabel("CONNECT")
     .setGroup(artnetGroup)
     ;
     
  // Status text
  cp5.addTextlabel("artnetStatus")
     .setPosition(20, 100)
     .setText("Status: " + (artNetEnabled ? "Enabled" : "Disabled"))
     .setGroup(artnetGroup)
     ;
}// Controls.pde
// Functions for setting up and managing UI controls

void setupControls() {
  // Calculate total height needed for LEDs to position controls below
  float ledsHeight = ledGrid.yPos + ledGrid.height + 20; // Grid height
  
  // Add space for the LED strip (account for multiple rows)
  int maxLedsPerRow = (int) Math.floor((1300 - 100) / (ledStrip.ledSize + ledStrip.spacing));
  int rowCount = (int) Math.ceil((float)stripCount / maxLedsPerRow);
  float stripHeight = rowCount * (ledStrip.ledSize + ledStrip.spacing) + 10;
  ledsHeight = ledStrip.yPos + stripHeight + 50; // Position controls below the strip
  
  // Create groups for grid and strip controls
  setupGridControlGroup(ledsHeight);
  setupStripControlGroup(ledsHeight);
  
  // Create group for ArtNet settings
  setupArtNetControlGroup(ledsHeight);
}

void setupGridControlGroup(float yPos) {
  // Create a group for grid controls
  Group gridGroup = cp5.addGroup("Grid Controls")
    .setPosition(160, yPos)
    .setWidth(440) // Wider group
    .setBackgroundHeight(480) // Taller for all controls
    .setBackgroundColor(color(240))
    .setBarHeight(25)
    .setColorBackground(color(60, 60, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    .disableCollapse()
    ;
    
  // Start color wheel - following example layout
  cp5.addColorWheel("gridStartColorWheel")
    .setPosition(20, 40)
    .setSize(190, 190) // Larger wheel
    .setRGB(gridStartColor)
    .setLabel("START COLOR")
    .setGroup(gridGroup)
    ;
    
  // End color wheel
  cp5.addColorWheel("gridEndColorWheel")
    .setPosition(230, 40)
    .setSize(190, 190) // Larger wheel
    .setRGB(gridEndColor)
    .setLabel("END COLOR")
    .setGroup(gridGroup)
    ;
  
  // Effect dropdown - positioned below color wheels with enough space for preview
  cp5.addScrollableList("gridEffect")
    .setPosition(20, 280) // Below color wheels and preview
    .setSize(190, 140)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("none", "solid", "pulse", "linear", "constrainbow", "rainbow", "wipe"))
    .setValue(2) // Default to pulse (index 2)
    .setLabel("EFFECT")
    .setGroup(gridGroup)
    ;
  
  // Linear fade angle slider
  cp5.addSlider("gridLinearAngle")
    .setPosition(230, 280) // Aligned with effect dropdown
    .setSize(190, 20)
    .setRange(0, 360)
    .setValue(0)
    .setLabel("LINEAR FADE ANGLE")
    .setGroup(gridGroup)
    ;
  
  // Speed slider
  cp5.addSlider("gridSpeed")
    .setPosition(230, 330) // Below angle slider
    .setSize(190, 20)
    .setRange(0.1, 10)
    .setValue(1)
    .setLabel("SPEED")
    .setGroup(gridGroup)
    ;
  
  // Playback mode dropdown - positioned below both sliders
  cp5.addScrollableList("gridPlayback")
    .setPosition(230, 380) // Below the speed slider
    .setSize(190, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("loop", "boomerang", "once"))
    .setValue(0) // Default to loop
    .setLabel("PLAYBACK MODE")
    .setGroup(gridGroup)
    ;
}

void setupStripControlGroup(float yPos) {
  // Create a group for strip controls
  Group stripGroup = cp5.addGroup("Strip Controls")
    .setPosition(620, yPos)
    .setWidth(440) // Wider group
    .setBackgroundHeight(480) // Taller for all controls
    .setBackgroundColor(color(240))
    .setBarHeight(25)
    .setColorBackground(color(100, 60, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    .disableCollapse()
    ;
    
  // Start color wheel - following example layout
  cp5.addColorWheel("stripStartColorWheel")
    .setPosition(20, 40)
    .setSize(190, 190) // Larger wheel
    .setRGB(stripStartColor)
    .setLabel("START COLOR")
    .setGroup(stripGroup)
    ;
    
  // End color wheel
  cp5.addColorWheel("stripEndColorWheel")
    .setPosition(230, 40)
    .setSize(190, 190) // Larger wheel
    .setRGB(stripEndColor)
    .setLabel("END COLOR")
    .setGroup(stripGroup)
    ;
  
  // Effect dropdown - positioned below color wheels with enough space for preview
  cp5.addScrollableList("stripEffect")
    .setPosition(20, 280) // Below color wheels and preview
    .setSize(190, 140)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("none", "solid", "pulse", "linear", "constrainbow", "rainbow", "wipe"))
    .setValue(2) // Default to pulse (index 2)
    .setLabel("EFFECT")
    .setGroup(stripGroup)
    ;
  
  // LED count input
  cp5.addNumberbox("stripCount")
    .setPosition(230, 280) // Aligned with effect dropdown
    .setSize(190, 20)
    .setRange(1, 300)
    .setValue(72)
    .setMultiplier(1)
    .setDirection(Controller.HORIZONTAL)
    .setLabel("NUMBER OF LEDS")
    .setGroup(stripGroup)
    ;
  
  // Speed slider
  cp5.addSlider("stripSpeed")
    .setPosition(230, 330) // Below LED count
    .setSize(190, 20)
    .setRange(0.1, 10)
    .setValue(0.5)
    .setLabel("SPEED")
    .setGroup(stripGroup)
    ;
  
  // Playback mode dropdown - positioned below speed slider
  cp5.addScrollableList("stripPlayback")
    .setPosition(230, 380) // Below the speed slider
    .setSize(190, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(java.util.Arrays.asList("loop", "boomerang", "once"))
    .setValue(0) // Default to loop
    .setLabel("PLAYBACK MODE")
    .setGroup(stripGroup)
    ;
}

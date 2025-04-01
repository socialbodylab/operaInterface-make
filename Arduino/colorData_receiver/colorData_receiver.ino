#include <ArtnetWifi.h>
#include <Arduino.h>
#include <Adafruit_NeoPixel.h>

//Wifi settings
const char* ssid = "rur";
const char* password = "rurconnect";
IPAddress local_IP(192,168,137, 10);
IPAddress gateway(192,168,137, 1);
IPAddress subnet(255, 255, 255, 0);

// Neopixel settings
const int LEDbrightness = 50;
const int badgeLEDs = 32; 
const int numberOfChannels_badge = badgeLEDs * 3; 
const byte badgeDataPin = 32;
Adafruit_NeoPixel badge = Adafruit_NeoPixel(badgeLEDs, badgeDataPin, NEO_GRB + NEO_KHZ800);

//Neopixel collar settings
const int collarLEDs = 30;
const int numberOfChannels_collar = collarLEDs * 3;
const byte collarDataPin = 12;
Adafruit_NeoPixel collar = Adafruit_NeoPixel(collarLEDs, collarDataPin, NEO_GRB + NEO_KHZ800);

// Artnet settings
ArtnetWifi artnet;

// Buffering for smoother updates
uint8_t badgeBuffer[badgeLEDs * 3];
uint8_t collarBuffer[collarLEDs * 3];
bool dataReady = false;

// FPS calculation variables
unsigned long frameCount = 0;
unsigned long packetCount = 0;
unsigned long lastFpsTime = 0;
const unsigned long fpsInterval = 1000; // Update FPS every second

// function prototypes
void onDmxFrame(uint16_t universe, uint16_t length, uint8_t sequence, uint8_t* data);
bool ConnectWifi(void);

void setup()
{
  Serial.begin(115200);
  ConnectWifi();
  artnet.begin();
  badge.begin();
  collar.begin();

  // Set brightness
  badge.setBrightness(LEDbrightness);
  collar.setBrightness(LEDbrightness);

  // Initialize timing for FPS calculation
  lastFpsTime = millis();

  // This will be called for each packet received
  artnet.setArtDmxCallback(onDmxFrame);
  
  Serial.println("Setup complete. Monitoring FPS...");
}

void loop()
{
  // We call the read function inside the loop
  artnet.read();
  
  // Calculate and display FPS every second
  unsigned long currentTime = millis();
  if (currentTime - lastFpsTime >= fpsInterval) {
    float framesFps = frameCount * 1000.0 / (currentTime - lastFpsTime);
    float packetsFps = packetCount * 1000.0 / (currentTime - lastFpsTime);
    
    Serial.print("FPS - LED Updates: ");
    Serial.print(framesFps, 1);
    Serial.print(", Art-Net Packets: ");
    Serial.print(packetsFps, 1);
    
    // Add more system info
    Serial.print(", Free Heap: ");
    Serial.print(ESP.getFreeHeap());
    Serial.print(" bytes, WiFi RSSI: ");
    Serial.print(WiFi.RSSI());
    Serial.println(" dBm");
    
    // Reset counters
    frameCount = 0;
    packetCount = 0;
    lastFpsTime = currentTime;
  }
  
  // If new data has arrived, update the LEDs
  if(dataReady) {
    // Update badge LEDs from buffer
    for(int i = 0; i < badgeLEDs; i++) {
      badge.setPixelColor(i, 
                         badgeBuffer[i * 3], 
                         badgeBuffer[i * 3 + 1], 
                         badgeBuffer[i * 3 + 2]);
    }
    
    // Update collar LEDs from buffer
    for(int i = 0; i < collarLEDs; i++) {
      collar.setPixelColor(i, 
                          collarBuffer[i * 3], 
                          collarBuffer[i * 3 + 1], 
                          collarBuffer[i * 3 + 2]);
    }
    
    // Show the pixels
    badge.show();
    collar.show();
    
    // Increment frame counter for FPS calculation
    frameCount++;
    
    // Reset the data flag
    dataReady = false;
  }
}

// Connect to wifi – returns true if successful or false if not
bool ConnectWifi()
{
  bool state = true;
  int i = 0;

  WiFi.begin(ssid, password);
  WiFi.config(local_IP, gateway, subnet);
  Serial.println("");
  Serial.println("Connecting to WiFi");
  
  // Wait for connection
  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    if (i > 20){
      state = false;
      break;
    }
    i++;
  }
  if (state){
    Serial.println("");
    Serial.print("Connected to ");
    Serial.println(ssid);
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    //turn on built in LED when connected
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    Serial.println("");
    Serial.println("Connection failed.");
  }
  
  return state;
}

void onDmxFrame(uint16_t universe, uint16_t length, uint8_t sequence, uint8_t* data)
{
  // Process badge data (first portion of the data array)
  int maxBadgeBytes = min((int)length, badgeLEDs * 3);
  for (int i = 0; i < maxBadgeBytes; i++) {
    badgeBuffer[i] = data[i];
  }
  
  // Process collar data (remaining portion of the data array)
  if(length > badgeLEDs * 3) {
    int collarDataStart = badgeLEDs * 3;
    int maxCollarBytes = min((int)length - collarDataStart, collarLEDs * 3);
    
    for(int i = 0; i < maxCollarBytes; i++) {
      collarBuffer[i] = data[collarDataStart + i];
    }
  }
  
  // Increment packet counter for FPS calculation
  packetCount++;
  
  // Set the data ready flag
  dataReady = true;
}
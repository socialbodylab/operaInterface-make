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
const int badgeLEDs = 32; 
const int numberOfChannels_badge = badgeLEDs * 3; 
const byte badgeDataPin = 32;
Adafruit_NeoPixel badge = Adafruit_NeoPixel(badgeLEDs, badgeDataPin, NEO_GRB + NEO_KHZ800);


//Neopixel collar settings
const int collarLEDs = 72;
const int numberOfChannels_collar = collarLEDs * 3;
const byte collarDataPin = 12;
Adafruit_NeoPixel collar = Adafruit_NeoPixel(collarLEDs, collarDataPin, NEO_GRB + NEO_KHZ800);



// Artnet settings
ArtnetWifi artnet;


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

  // this will be called for each packet received
  artnet.setArtDmxCallback(onDmxFrame);
}

void loop()
{
  // we call the read function inside the loop
  artnet.read();
}
// connect to wifi – returns true if successful or false if not
bool ConnectWifi(void)
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

  badge.setBrightness(20);
  collar.setBrightness(20);

  // read universe and put into the right part of the display buffer
  for (int i = 0; i < badgeLEDs; i++)
  {
    
      badge.setPixelColor(i, data[i * 3], data[i * 3 + 1], data[i * 3 + 2]);
  }
 

  //set led colors for collar
  int collarStart = 0;
  for (int i = badgeLEDs; i < badgeLEDs + collarLEDs; i++)
  {
    collar.setPixelColor(collarStart, data[i * 3], data[i * 3 + 1], data[i * 3 + 2]);
    collarStart++;
  }

  //show the pixels
    badge.show();
    collar.show();


}
#include <Wire.h>
// Some logic copied from https://github.com/adafruit/Adafruit_MPL115A2/
#define NUM_SENSORS 5
float a0[NUM_SENSORS];
float b1[NUM_SENSORS];
float b2[NUM_SENSORS];
float c12[NUM_SENSORS];

void initialize() {
    // s 0C
  Wire.beginTransmission(0x06);
  Wire.endTransmission();
  
  // s C0 12 01
  Wire.beginTransmission(0x60);
  Wire.write(0x12);
  Wire.write(0x01);
  Wire.endTransmission();
  
  // s 0D
  Wire.requestFrom(0x06, 1);
  
  delay(5);
}

void readCoeffs(byte num) {
  
  // Select sensor
  Wire.beginTransmission(0x30+num);
  Wire.endTransmission();
  
  // Request coefficients
  Wire.beginTransmission(0x60);
  Wire.write(0x04);
  Wire.endTransmission();
  Wire.requestFrom(0x60, 8);
  int16_t a0coeff = (( (uint16_t) Wire.read() << 8) | Wire.read());
  int16_t b1coeff = (( (uint16_t) Wire.read() << 8) | Wire.read());
  int16_t b2coeff = (( (uint16_t) Wire.read() << 8) | Wire.read());
  int16_t c12coeff = (( (uint16_t) (Wire.read() << 8) | Wire.read())) >> 2;
  // Turn sensor off
  Wire.requestFrom(0x30+num, 1);
  
  a0[num] = (float)a0coeff / 8;
  b1[num] = (float)b1coeff / 8192;
  b2[num] = (float)b2coeff / 16384;
  c12[num] = (float)c12coeff;
  c12[num] /= 4194304.0;
}

void setup () {
  Wire.begin();
  Serial.begin(9600);
  initialize();
  for(int i=0;i<NUM_SENSORS;i++) {
    readCoeffs(i);
  }
}
void readNum(byte num, float* oTemp, float* oPressure)
{
  // Select sensor
  Wire.beginTransmission(0x30+num);
  Wire.endTransmission();

  // Request P/T data
  Wire.beginTransmission(0x60);
  Wire.write(0x00);
  Wire.endTransmission();

  Wire.requestFrom(0x60, 4);
  uint16_t pressure = (( (uint16_t) Wire.read() << 8) | Wire.read()) >> 6;
  uint16_t temp = (( (uint16_t) Wire.read() << 8) | Wire.read()) >> 6;
  
  // Turn sensor off
  Wire.requestFrom(0x30+num, 1);

  float pressureComp = a0[num] + (b1[num] + c12[num]  * temp)  * pressure + b2[num] * temp;

  // Calculate temp & pressure
  *oPressure = ((65.0F / 1023.0F) * pressureComp) + 50.05F; // kPa
  *oTemp = ((float) temp - 498.0F) / -5.35F + 25.0F; // C
  //*oPressure = pressure;
  //*oTemp = temp;
}
// Copied from http://www.varesano.net/blog/fabio/sending-float-variables-over-serial-without-loss-precision-arduino-and-processing
void serialFloatPrint(float f) {
  byte * b = (byte *) &f;
  for(int i=0; i<4; i++) {
    
    byte b1 = (b[i] >> 4) & 0x0f;
    byte b2 = (b[i] & 0x0f);
    
    char c1 = (b1 < 10) ? ('0' + b1) : 'A' + b1 - 10;
    char c2 = (b2 < 10) ? ('0' + b2) : 'A' + b2 - 10;
    
    Serial.print(c1);
    Serial.print(c2);
  }
}
void loop() {
  initialize();
  
  for(int i=0;i<NUM_SENSORS;i++)
  {
    float oTemp, oPressure;
    readNum(i, &oTemp, &oPressure);
    serialFloatPrint(oTemp);
    serialFloatPrint(oPressure);
  }
  Serial.println();
}



#include <Wire.h>

void setup () {
  Wire.begin();
  Serial.begin(9600);
}
void loop() {
  // s 0C
  Wire.beginTransmission(0x06);
  Wire.endTransmission();
  
  // s C0 12 01
  Wire.beginTransmission(0x60);
  Wire.write(0x12);
  Wire.write(0x01);
  Wire.endTransmission();
  
  // s 0D
  Wire.requestFrom(0x06, 0);
  
  delay(5);
  
  // Data
  
  Wire.beginTransmission(0x30);
  Wire.endTransmission();
  Wire.beginTransmission(0x60);
  Wire.write(0x00);
  Wire.requestFrom(0x30, 4);
  byte b1 = Wire.read();
  byte b2 = Wire.read();
  byte b3 = Wire.read();
  byte b4 = Wire.read();
  Wire.requestFrom(0x30, 0);
  int pressure = (( (uint16_t) b1 << 8) | b2) >> 6;
  int temp = (( (uint16_t) b3 << 8) | b4) >> 6;
  Serial.write(pressure);
  Serial.write(' ');
  Serial.write(temp);
  Serial.write('\n');
}

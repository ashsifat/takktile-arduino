#include <Wire.h>

void setup () {
  Wire.begin();
  Serial.begin(9600);
}
void readNum(byte num, float* oTemp, float* oPressure)
{
  // Select sensor
  Wire.beginTransmission(0x30+num);
  Wire.endTransmission();

  // Request coefficients
  Wire.beginTransmission(0x60);
  Wire.write(0x04);
  Wire.endTransmission();
  Wire.requestFrom(0x60+num, 8);
  int16_t a0coeff = (( (uint16_t) Wire.read() << 8) | Wire.read());
  int16_t b1coeff = (( (uint16_t) Wire.read() << 8) | Wire.read());
  int16_t b2coeff = (( (uint16_t) Wire.read() << 8) | Wire.read());
  int16_t c12coeff = (( (uint16_t) (Wire.read() << 8) | Wire.read())) >> 2;

  float _mpl115a2_a0 = (float)a0coeff / 8;
  float _mpl115a2_b1 = (float)b1coeff / 8192;
  float _mpl115a2_b2 = (float)b2coeff / 16384;
  float _mpl115a2_c12 = (float)c12coeff;
  _mpl115a2_c12 /= 4194304.0;

  // Request raw sensor measurements
  Wire.beginTransmission(0x60);
  Wire.write(0x00);
  Wire.endTransmission();

  Wire.requestFrom(0x60, 4);
  uint16_t pressure = (( (uint16_t) Wire.read() << 8) | Wire.read()) >> 6;
  uint16_t temp = (( (uint16_t) Wire.read() << 8) | Wire.read()) >> 6;

  float pressureComp = _mpl115a2_a0 + (_mpl115a2_b1 + _mpl115a2_c12 * temp ) * pressure + _mpl115a2_b2 * temp;

  // Turn sensor off
  Wire.requestFrom(0x30+num, 1);

  // Calculate temp & pressure
  *oPressure = ((65.0F / 1023.0F) * pressureComp) + 50.05F; // kPa
  *oTemp = ((float) temp - 498.0F) / -5.35F + 25.0F; // C
  //*oPressure = pressure;
  //*oTemp = temp;
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
  Wire.requestFrom(0x06, 1);
  
  delay(5);
  
  for(int i=0;i<5;i++)
  {
    float oTemp, oPressure;
    Serial.print(i);
    Serial.print(' ');
    readNum(i, &oTemp, &oPressure);
    Serial.print(oTemp);
    Serial.print(' ');
    Serial.print(oPressure);
    Serial.print(' ');
  }
  Serial.print('\n');
}



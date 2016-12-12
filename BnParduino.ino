#include <Servo.h>

Servo servo1;
Servo servo2;

int pos = 0;

void setup() {
  servo1.attach(11);
  servo2.attach(10);
  Serial.begin(9600);
}

void loop() {
  while (Serial.available() <= 0);
  servo1.write(Serial.read());
  while (Serial.available() <= 0);
  servo2.write(Serial.read());
}

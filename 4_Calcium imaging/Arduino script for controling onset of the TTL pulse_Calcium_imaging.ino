const int interruptPin     = 2;  //Input from EM-CCD     [Digital #2 <-> Ground]
const int pin_out          = 5;  //Output to LED Driver  [Digital #5 <-> Ground]
const unsigned int ledOnFrame     = 10; //You can set the timing of LED flash by specifying the EM-CCD frame number (#).
const unsigned int ledOnDuration  = 2500;  //You can set the duration of LED flash by specifying time in msec.
const unsigned int ledOffDuration  = 7500;
volatile unsigned int pulse = 0;  //This defines the counted "pulse" number corresponding to the captured frame number.

void count_pulse() {
  pulse++;  //This "count_pulse" function will increase the value of "pulse" one by one.
}

void setup() {
  Serial.begin(9600); //ボーレートの設定
  pinMode(interruptPin, INPUT); //The TTL signals from EM-CCD firing port (Andor).
  pinMode(pin_out, OUTPUT); //The TTL signals to the LED Driver (ThorLabs).
  digitalWrite(pin_out, LOW); //とにかくLEDを点けないでおく！（この行は不要かも？）
  attachInterrupt(digitalPinToInterrupt(interruptPin), count_pulse, RISING);  //２番ピンの入力を監視して，「立ち上がり」を検出する．
}

void loop() {
  if (pulse == ledOnFrame) {
    detachInterrupt(digitalPinToInterrupt(interruptPin));
    digitalWrite(pin_out, HIGH);
    delay(ledOnDuration); // "ledOnDuration" (msec) の間だけ，LED を点灯する．
    digitalWrite(pin_out, LOW);
    delay(ledOffDuration);
    digitalWrite(pin_out, HIGH);
    delay(ledOnDuration); // "ledOnDuration" (msec) の間だけ，LED を点灯する．
    digitalWrite(pin_out, LOW);
    delay(ledOffDuration);
    digitalWrite(pin_out, HIGH);
    delay(ledOnDuration); // "ledOnDuration" (msec) の間だけ，LED を点灯する．
    digitalWrite(pin_out, LOW);
    delay(ledOffDuration);
    digitalWrite(pin_out, HIGH);
    delay(ledOnDuration); // "ledOnDuration" (msec) の間だけ，LED を点灯する．
    digitalWrite(pin_out, LOW);
    delay(ledOffDuration);
    digitalWrite(pin_out, HIGH);
    delay(ledOnDuration); // "ledOnDuration" (msec) の間だけ，LED を点灯する．
    digitalWrite(pin_out, LOW);
    delay(ledOffDuration);
    pulse++;  //これで，次のloopにはいると，pulse=ledOnFrame+1 になっているので，if には２度と戻ってこないはず.
  }
  else {
    //detachInterrupt(digitalPinToInterrupt(interruptPin));
    //delay(50); //とりあえず少し待つ（この行は不要かも？）
    //attachInterrupt(digitalPinToInterrupt(interruptPin), count_pulse, RISING);
  }
}

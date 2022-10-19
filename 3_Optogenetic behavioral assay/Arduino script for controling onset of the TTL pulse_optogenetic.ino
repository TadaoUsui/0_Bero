const byte interruptPin     = 2;      // Set an input pin# from bouton switch.
const byte pin_out          = 20;     // Set a TTL output pin#
const int ledOnDuration     = 1000;   // Set a duration of the "TTL on" time in ms.
volatile byte state         = LOW;    // Set a "state" binary as LOW (= 0).

void setup(){
  pinMode(interruptPin, INPUT);       // Tact switch signals.
  pinMode(pin_out, OUTPUT);           // Set TTL output pin as OUTPUT pin
  attachInterrupt(digitalPinToInterrupt(interruptPin), flip, RISING);
}                                     // Set interruption (pin#, function called and detection mode)

void loop(){
  if (state == LOW) { 
    digitalWrite(pin_out, LOW);       // If "state" is "LOW", do not output TTL.
  }
  else {
    detachInterrupt(digitalPinToInterrupt(interruptPin));
    digitalWrite(pin_out, HIGH);      // If "state" is "HIGH", stop "attachInterrupt" and start a TTL pulse.
    delay(ledOnDuration);             // Wait for "ledOnDuration" (msec). This corresponds to the "TTL on" time.
    digitalWrite(pin_out, LOW);       // Stop the TTL pulse.
    state = !state;                   // Reset "state" as "LOW".
    attachInterrupt(digitalPinToInterrupt(interruptPin), flip, RISING);
  }
}

void flip(){                          // Define a void function named flip().
  state = !state;                     // Flip the "state" binary (LOW ⇔ HIGH).
}
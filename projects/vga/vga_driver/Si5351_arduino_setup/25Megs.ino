#include <Adafruit_SI5351.h>
void setup() {
  // put your setup code here, to run once:
  Adafruit_SI5351 clockgen = Adafruit_SI5351();

  if (clockgen.begin() != ERROR_NONE) {
    Serial.print("somthin went wrong");
    while(1);
  }
clockgen.setupPLLInt(SI5351_PLL_A, 16);
clockgen.setupMultisynthInt(0, SI5351_PLL_A, SI5351_MULTISYNTH_DIV_8);
clockgen.setupRdiv(0, SI5351_R_DIV_2);
clockgen.enableOutputs(true);
}

void loop() {
  // put your main code here, to run repeatedly:

}

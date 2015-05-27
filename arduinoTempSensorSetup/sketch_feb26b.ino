/*
 Thermometer
 adavid7@uw.edu
 2/6/14
 
 This program implements a simple thermometer by reading data from a temperature sensor.
 
 It displays the temperature values in the serial monitor window so it can be used for
 debugging. To see them, open the serial monitor window.
 
 Or, more importantly, if the serial port is connected to another application on a
 host computer, it will receive the temperature data and can do something nice
 with it (like make a nice real-time graph). To do this, close the serial monitor window
 and the temperature values will be sent to the host. Processing can be used to easily
 visualize those values.
 
 */



// this constant shows where we'll find the temp sensor on the Arduino board
const int sensorPin = A1; 

// this constant controls the sampling interval for temperature values
const int tempSampling = 500; // ms, 1 ms = 1/1000 second, so 500 = 1/2 second

// these variables are used to calculate the temperature
int   sensorValue;  // raw analog data
int   sensorMV;     // corresponding voltage (millivolts)
float tempCent;     // degrees Centigrade
float tempFahr;     // degrees Fahrenheit


void setup() {

  // setup the pin for the temp sensor input
  pinMode(sensorPin, INPUT);  

  // setup the serial port for sending data to the serial monitor or host computer
  Serial.begin(9600);

}


void loop() {

  // read the raw analog value of the temp sensor
  sensorValue = analogRead(sensorPin); 

  // an Arduino analog port returns a 10-bit value (0 - 1023)
  // convert it to an equivalent voltage level, in millivolts (between 0 and 5000, since the Arduino port is +5V)
  sensorMV = map(sensorValue, 0, 1023, 0, 4999);

  // now convert this voltage to degrees Centigrade
  // this calculation comes from the spec of the specific sensor we are using:
  // TMP36, details here: http://www.adafruit.com/products/165
  tempCent = (sensorMV - 500) / 10.0;

  // and convert that to Fahrenheit
 
  // write the Fahrenheit value out to the serial port as ASCII text 
  // this will be in the format (xx.xx) because that is what the Arduino print library uses
  // and that is because the Arduino has no floating point processor, so it does the best it can
  Serial.println(tempCent);

  // since temperature doesn't change so rapidly, we can set the delay here until the next check
  // this should also work with shorter or longer delays, or zero for ultra real-time (OK, 9600 baud...)
  delay (tempSampling); 

}











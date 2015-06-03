/*
The following program help setup the the arduino to read data from 
temperature sensor, which later can be read by the paired processing
program. The data output setup by this program will be the current read 
temperature in Celsius. 

The temperature sensor used here is TMP36

The code followed Thermometer code by Andy (adavid7@uw.edu), with modification.

yyyuan 6/3/2015
*/
 
const int sensorPin = A1; 
const int tempSampling = 500; 

int   sensorValue;  
int   sensorMV;     
float tempC;     
  
void setup() {

  pinMode(sensorPin, INPUT);  
  Serial.begin(9600);

}


void loop() {
  sensorValue = analogRead(sensorPin); 
  sensorMV = map(sensorValue, 0, 1023, 0, 4999);

  tempC = (sensorMV - 500) / 10.0;
  Serial.println(tempC);
  delay (tempSampling); 
  
}











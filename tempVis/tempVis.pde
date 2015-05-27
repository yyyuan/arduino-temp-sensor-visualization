/*
A small program for record and visualize the temperature read from 
the arduino board. 
by Irene Ye Yuan 2/26/2015
*/
import processing.serial.*;

// global variable for storing temps, up to 60 points
float[][] temps;
String[] times;
int serialPortNum = 0;
int count = 0;
int currentUnit = 0;  // 0 for C, 1 for F, 2 for K
int hoverUnit = 0;

float previousX = 225; 
float previousY = 300;
float pointX, pointY;

float[] currentTemp = new float[3];
float[] maxTemp = new float[3];
float[] minTemp = new float[3];  //range of expected values
float[] currentMin = new float[3];
float[] currentMax = new float[3];

String currentTime;

float countMin = 0;
float countMax = 0;

Serial myPort; 

int duration = 1000; 
int startTime; 

PFont numFont;
PFont textFont;

color activeColor = color(255);
color inactiveColor = color(150);
color hoverColor = color(240);

color colorC, colorF, colorK;

// for buttons
int buttonX = 20-10+10;
int buttonY = 245-20+50;
int buttonW = 120;
int buttonH = 25;

void setup() {
  // set screen size
  size(600,400);
  smooth();
  
  //
  setTemp(currentTemp,18);
  setTemp(maxTemp,30);
  setTemp(minTemp,10);
  
  temps = new float[60][3];
  times = new String[60];
  //instantiate a serial port object
  myPort = new Serial(this, Serial.list()[serialPortNum], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');  
  
  // for animation
  startTime = millis();

  // set font
  numFont = loadFont("DS-Digital-Bold.vlw");
  textFont = loadFont("DS-Digital.vlw");

}

void draw() {
  // test
  String hour, minute, second;
  if (hour() < 10){hour = "0"+str(hour());}
  else{hour = str(hour());}
  if (minute() < 10){minute = "0"+str(minute());}
  else{minute = str(minute());}
  if (second() < 10){second = "0"+str(second());}
  else{second = str(second());}
  
  currentTime = hour + ":" + minute + ":" + second;
  //println(currentTime);
  
  // check current unit
  if(currentUnit == 0){
    colorC=activeColor;
    colorF=inactiveColor; colorK=inactiveColor;}
  else if(currentUnit == 1){
    colorF=activeColor;
    colorC=inactiveColor; colorK=inactiveColor;
  }
  else if(currentUnit == 2){
    colorK=activeColor;
    colorF=inactiveColor; colorC=inactiveColor;}
    
  // check hover
  if(hoverUnit == 1){colorC=hoverColor;}
  else if(hoverUnit == 2){colorF=hoverColor;}
  else if(hoverUnit == 3){colorK=hoverColor;}
  
  // set the background
  background(25);
  translate(10,50);

  //
  textFont(textFont, 25);
  text("Current Time",10,15);
  textFont(numFont, 30);
  text(currentTime,20,50);
  
  // current temperature
  textFont(textFont, 25);
  text("Current Temp",10,15+100);
  textFont(numFont, 30);
  text(currentTemp[currentUnit],10,50+100);

  // title
  textFont(textFont, 25);
  text("Unit Display",10,15+200);
  // add button
  textFont(numFont, 20);
  
  fill(colorC);
  text("Celsius",20,245);  
  fill(colorF);
  text("Fahrenheit",20,275);
  fill(colorK);
  text("Kelvin",20,305);
    
  for(int i = 0; i < count; i++){
    if(temps[i][currentUnit] < currentMin[currentUnit]){
      setTemp(currentMin,temps[i][0]);
      countMin = i;}
    else if(temps[i][currentUnit] > currentMax[currentUnit]){
      setTemp(currentMax,temps[i][0]);
      countMax = i;}
    pointX = map( i, 1, 60, 225, 505);
    pointY = map( temps[i][currentUnit], minTemp[currentUnit], maxTemp[currentUnit], 300, -50 );
    fill(255);
    stroke(25);
    rect(pointX,pointY,5,5);
    // draw the time label
    fill(255);
    textFont(textFont, 16);
    text(times[0], 180, 300);
    text(times[0], 180, 300);
    if(i==count-1){ text(times[count-1], pointX, 300);}
    stroke(255);
    line(180,280,550, 280);
  }
  
  
  float minY = map( currentMin[currentUnit], minTemp[currentUnit], maxTemp[currentUnit], 300, -50 );
  float maxY = map( currentMax[currentUnit], minTemp[currentUnit], maxTemp[currentUnit], 300, -50 );
  float minX = map( countMin, 1, 60, 225, 505);
  float maxX = map( countMax, 1, 60, 225, 505);
  String minS = "Minimum: "+str(currentMin[currentUnit]);
  String maxS = "Maximum: "+str(currentMax[currentUnit]);

  text(maxS, maxX-20, maxY-10);
  text(minS, minX-20, minY+25);

  if((mouseX >= buttonX && mouseX <= buttonX + buttonW &&
    mouseY >= buttonY && mouseY <= buttonY + buttonH) ){
      hoverUnit = 1;
    }
  else if((mouseX >= buttonX && mouseX <= buttonX + buttonW &&
    mouseY >= buttonY + 30 && mouseY <= buttonY + 30 + buttonH) ){
      hoverUnit = 2;
    }
    else if((mouseX >= buttonX && mouseX <= buttonX + buttonW &&
    mouseY >= buttonY + 60 && mouseY <= buttonY + 60 + buttonH) ){
      hoverUnit = 3;
    }
    else{hoverUnit = 0;}
    
  if( millis() < startTime + duration ){  
    // do nothing and wait for 
  }
  
  //
  else{
    //
    setTemp(currentMin,currentTemp[0]);
    setTemp(currentMax,currentTemp[0]);
    if(count< 60){
      setTemp(temps[count],currentTemp[0]);
      times[count] = currentTime;
      count++;
    }
    //
    else{
      for (int i = 0; i < temps.length-1; i++) {
        setTemp(temps[i], temps[i+1][0]); 
      }
      // Add a new random value
      setTemp(temps[temps.length-1], currentTemp[0]); 
      //
      for (int i = 0; i < times.length-1; i++) {
        times[i] = times[i+1]; 
      }
      // Add a new random value
      times[times.length-1] = currentTime;
    }
    //println(temps[count-1] );
    //println(pointX,pointY);
    startTime = millis();

  }
}

void mouseClicked(){
   if((mouseX >= buttonX && mouseX <= buttonX + buttonW &&
    mouseY >= buttonY && mouseY <= buttonY + buttonH) ){
      currentUnit = 0;
    }
    else if((mouseX >= buttonX && mouseX <= buttonX + buttonW &&
    mouseY >= buttonY + 30 && mouseY <= buttonY + 30 + buttonH) ){
      currentUnit = 1;
    }
    else if((mouseX >= buttonX && mouseX <= buttonX + buttonW &&
    mouseY >= buttonY + 60 && mouseY <= buttonY + 60 + buttonH) ){
      currentUnit = 2;
    }
}

//SERIAL EVENT: called whenever serial port has data
void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n'); //read the serial port

  if (inString != null) {  //check that serial port has actual data...
    inString = trim(inString);  //... if so, trim whitespace... 
    float currentC= float(inString);  //... and set currentTemp
    
    float currentF = (currentC * 9 / 5.0) + 32.0; 
    float currentK = 273.15 + currentC;
    
    currentTemp[0] = currentC;
    currentTemp[1] = currentF;
    currentTemp[2] = currentK;
     
  }
}

void setTemp(float[] temp, float celsius){
  temp[0] = celsius;
  temp[1] = (celsius * 9 / 5.0) + 32.0; 
  temp[2] = 273.15 + celsius;
}

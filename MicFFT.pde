/*
FFT of the Input Mic Woopwoop
-----------------------------
RobotGrrl.com
*/

import ddf.minim.analysis.*;
import ddf.minim.*;

// Audio
Minim minim;
FFT fftLog;
AudioInput input;

// Variables for the canvas & ellipses
int canvasW = 1024;
int canvasH = 600;
int sizew = 20;
int sizeh = 15;

void setup() {
  
  // Woo!
  size(canvasW, canvasH);
  background(0);
  
  // Start the audio
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 2048);
  
  // Start the FFT
  fftLog = new FFT(input.bufferSize(), input.sampleRate());
  fftLog.logAverages(22, 3);
  fftLog.window(FFT.HAMMING);
  
  // Settings for drawing
  colorMode(HSB, 100);
  ellipseMode(CENTER);
  smooth();
  noStroke();
  
}

void draw() {

  // Calculate the FFT from the input
  fftLog.forward(input.mix);
         
  // Iterate through each of the FFT "points"
  for(int i = 0; i < fftLog.avgSize(); i++) {         
    
    // If i is < the average size - 29, clean the
    // screen and draw a black rectangle
    if(i < fftLog.avgSize() - 29) {
      fill(color(0,0,0,20));
      rect(0,0,canvasW,canvasH);
    }
          
    // Get the data from the FFT and colour it
    float amp = sqrt(sqrt(fftLog.getAvg(i)))*150;
    float h = i * 100/fftLog.avgSize();
    h -= 10;
    h = 100 - h;
    float s = 70;
    float b = amp/3 * 100;
    float a = 100;
    fill(color(h,s,b,a));
       
    // Calculate the x&y, draw the ellipse
    float x = i*24 + 150;
    float y = canvasH - amp-50;
    ellipse(x, y, sizew, sizeh);
  }

}

void stop() {
  // Make sure to close everything!
  input.close();
  super.stop();
}

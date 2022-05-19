import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import com.hamoid.*;

import processing.sound.*;

String audioFileName = ""; 

float smoothingFactor = 0.25; 

float unit;
int groundLineY;
PVector center;

int state;

AudioPlayer track;
ddf.minim.analysis.FFT fft;
processing.sound.FFT fftSound;
AudioIn in;
Minim minim;  

int bands = 256;
float[] spectrum = new float[bands];
float[] sum = new float[bands];

boolean isMic = false;

void settings() {
  size(1080, 720, P3D);
  smooth(8);
}


void setup() { 
  hint(ENABLE_STROKE_PURE); 
  frameRate(120);
  
  state = 0;
unit = height / 100;
groundLineY = height * 3/4;
center = new PVector(width / 2, height * 3/4);
  
}

void fileSelected(File selection) {
  if (selection != null) {

    audioFileName = selection.getAbsolutePath();
    char[] buffer = audioFileName.toCharArray();
    for(int i = 0;i<buffer.length;i++){  
     if(buffer[i] == '\\'){
      buffer[i] = '/'; 
     }
    }
    audioFileName = String.valueOf(buffer);
    
    minim = new Minim(this);
    track = minim.loadFile(audioFileName, 2048);    
    track.play();
    
    fft = new ddf.minim.analysis.FFT( track.bufferSize(), track.sampleRate() );
    fft.linAverages(bands);
}
}


void draw() {
    background(0);
  if(fft != null){
    switch(state){
      case 0:          
      DrawCircles();
      break;
      case 1:
      DrawTerrain();
      break;
      case 2:
      DrawCubes();
      break;
    }
  }
  
  if(fftSound != null){
    switch(state){
      case 0:          
      DrawCirclesVoice();
      break;
      case 1:
      DrawTerrainVoice();
      break;
      case 2:
      DrawCubesVoice();
      break;
    }

  }
}

void DrawTerrainVoice(){
  spectrum = new float[bands];
  fftSound.analyze(spectrum);
  
  for(int i = 0; i < spectrum.length;i++){
    spectrum[i] *= 1000;
  }
  
  drawTerrain(spectrum);
}

void DrawTerrain(){
  fft.forward( track.mix );    
    spectrum = new float[bands];
    
    for(int i = 0; i < fft.avgSize(); i++)
    {
      spectrum[i] = fft.getAvg(i) / 2 + fft.getAvg(i) / 2; 
      sum[i] += (abs(spectrum[i]) - sum[i]) * smoothingFactor;
    }
   
    drawTerrain(sum);
}

void DrawCircles(){
  fft.forward( track.mix );    
    spectrum = new float[bands];
    
    for(int i = 0; i < fft.avgSize(); i++)
    {
      spectrum[i] = fft.getAvg(i) / 2 + fft.getAvg(i) / 2; 
      sum[i] += (abs(spectrum[i]) - sum[i]) * smoothingFactor;
    }
    
    drawAll(sum);
}

void DrawCirclesVoice(){
    spectrum = new float[bands];
  fftSound.analyze(spectrum);
  
  for(int i = 0; i < spectrum.length;i++){
    spectrum[i] *= 1000;
  }
  drawAll(spectrum);
}

void DrawCubes(){
  fft.forward( track.mix );    
    spectrum = new float[bands];
    float avg = 0;
    
    for(int i = 0; i < fft.avgSize(); i++)
    {
      spectrum[i] = fft.getAvg(i) / 2 + fft.getAvg(i) / 2; 
      sum[i] += (abs(spectrum[i]) - sum[i]) * smoothingFactor;
      avg += sum[i];
    }
    
    avg = (avg/sum.length)*40;
  
DrawGFX(avg);
}

void DrawCubesVoice(){
 spectrum = new float[bands];
  fftSound.analyze(spectrum);
  float avg = 0;
  for(int i = 0; i < spectrum.length;i++){
    avg += spectrum[i];
  }
  avg = (avg/spectrum.length)*100;
      
  DrawGFX(avg*200);
}

void DrawGFX(float avg){
      stroke(255);
  strokeWeight(2);
  noFill();
    rect(width/4, height/1.5-100, 350, 500, 15);
    rect(width-width/4, height/1.5-100, 350, 500, 15);
  
  stroke(255);
  strokeWeight(2);
  fill(255);
  rectMode(CENTER);
  ellipse(width/4, height/1.5-250, 100,100);
  ellipse(width-width/4, height/1.5-250, 100,100);
  rect(width/4, height/1.5, avg,avg,map(avg, 0, 270, 40, 0));
  rect(width-width/4, height/1.5, avg,avg,map(avg, 0, 270, 40, 0));
}

void keyPressed() {
  if (key == 'q') {  
    ResetAll();
    selectFile();
  }
  if(key == 's'){
    ResetAll();
    InitMic();
  }
  if(key == 'c'){
    state++;
    if(state == 3)
      state = 0;
  }
}

void ResetAll(){
  fft = null;
  fftSound = null;
  if(track != null)
      track.pause();
}

void InitMic(){
  fftSound = new processing.sound.FFT(this, bands);
  for(int i = 0; i< 3; i++){
      in = new AudioIn(this, 0);
      if(in != null)
        break;
  }
  in.start();
  fftSound.input(in);
}

void selectFile(){
    File start1 = new File(sketchPath("")+"/*.mp3"); 
      selectInput("Select a file to process:", "fileSelected", start1);
}

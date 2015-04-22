/**
  LeapSimon
  
  Developed by: Andres Bejarano
  Based on the original game Simon
*/

import de.voidplus.leapmotion.*;

//-------------------------------------
ViewManager viewManager;
AudioManager audioManager;

int halfWidth;
int halfHeight;

//Buttons variables
PImage buttonImg;
PImage[][] buttonsImgs;
int buttonImgWidth = 219;
int buttonImgHeight = 143;
int nButtons = 9;
int nButtonStates = 3;

//Numbers (GUI) variables
PImage numberImg;
PImage[] numbersImgs;
int numberImgWidth = 26;
int numberImgHeight = 48;

PImage scoreLifesImg;
PImage scoreImg;
PImage lifesImg;

//LeapMotion, hand and cursor variables
LeapMotion leapMotion;
PImage handImg;
PImage noHandImg;
PVector handLoc;
boolean isHand;
float pushThreshold = 50;

int halfHandImgWidth;
int halfHandImgHeight;


//--------------------------------------
boolean update = true;

void setup() 
{
  size(800, 600);
  halfWidth = width / 2;
  halfHeight = height / 2;
  
  //Loading number images
  numberImg = loadImage("numbers.png");
  numbersImgs = new PImage[10];
  for(int i = 0; i < 10; i += 1) 
  {
    numbersImgs[i] = numberImg.get(i * numberImgWidth, 0, numberImgWidth, numberImgHeight);
  }
  
  //Loading button images
  buttonImg = loadImage("buttons.png");
  buttonsImgs = new PImage[nButtons][nButtonStates];
  for(int i = 0; i < nButtons; i += 1) 
  {
    for(int j = 0; j < nButtonStates; j += 1) 
    {
      buttonsImgs[i][j] = buttonImg.get(j * buttonImgWidth, i * buttonImgHeight, buttonImgWidth, buttonImgHeight);
    }
  }
  
  //Loading score and lifes images
  scoreLifesImg = loadImage("scorelifes.png");
  lifesImg = scoreLifesImg.get(0, 0, 154, 49);
  scoreImg = scoreLifesImg.get(0, 49, 154, 49);
  
  //Loading hand image and no hand image
  handImg = loadImage("hand.png");
  halfHandImgWidth = handImg.width / 2;
  halfHandImgHeight = handImg.height / 2;
  noHandImg = loadImage("nohand.png");
  
  leapMotion = new LeapMotion(this);
  audioManager = new AudioManager(this);
  viewManager = new ViewManager();
}

void draw() 
{
  if(update) 
  {
    isHand = false;
    if(leapMotion != null) 
    {
      for(Hand h : leapMotion.getHands()) 
      {
        isHand = true;
        handLoc = h.getPosition();
        break;
      }
    }
    else 
    {
      println("No LeapMotion recognized");
    }
    viewManager.update();
  }
  else 
  {
    viewManager.draw();
    if(isHand) 
    {
      tint(255, 255);
      image(handImg, handLoc.x - halfHandImgWidth, handLoc.y - halfHandImgHeight);
      fill(255);
      ellipse(handLoc.x, handLoc.y, 10, 10);
    }
    else 
    {
      tint(255, 255);
      image(noHandImg, 0, 0);
    }
  }
  update = !update;
}




public class SimonView implements View, ButtonListener 
{
  
  public static final int STEP_1 = 0, STEP_2 = 1, STEP_3 = 2, STEP_4 = 3, STEP_5 = 4, STEP_6 = 5, STEP_7 = 6;
  public static final int FADING_TIME = 30, INITIAL_WAIT_TIME = 10, READY_IMG_TIME = 60, MAX_KEY_TIME = 30, MIN_KEY_TIME = 5, OK_FAIL_TIME = 60;
  public static final int READY_IMG = 0, OK_IMG = 1, FAIL_IMG = 2;
  public static final int SEQUENCES_TO_EXTRA_LIFE = 10, SEQUENCES_TO_REDUCE_PACE = 2;
  
  private ViewManager viewManager;
  
  private int timer;
  private int alpha;
  private int currentStep;
  
  private Button[] buttons;
  
  private ArrayList<Key> keys;
  private boolean isOk;
  private int keyTime;
  
  private PImage[] images;
  private PImage img;
  
  private int lifes;
  private int score;
  
  private int iKey;
  private int nKeys;
  private int keyValue;
  private int keyTimer;
  private int keyTimerPace;
  private boolean showingSequence;
  
  private int buttonPressed;
  
  //Drawing support variables
  private int n;
  private int i;
  private int xPos;
  private ArrayList<Integer> scoreDigits;
  private ArrayList<Integer> lifesDigits;
  
  public SimonView(ViewManager viewManager) 
  {
    this.viewManager = viewManager;
    
    buttons = new Button[4];
    buttons[0] = new Button((width - buttonImgWidth) / 2, (height / 4) - (buttonImgHeight / 2), buttonsImgs[2]);
    buttons[0].setButtonListener(this);
    buttons[1] = new Button((3 * width / 4) - (buttonImgWidth / 2), (height - buttonImgHeight) / 2, buttonsImgs[3]);
    buttons[1].setButtonListener(this);
    buttons[2] = new Button((width - buttonImgWidth) / 2, (3 * height / 4) - (buttonImgHeight / 2), buttonsImgs[4]);
    buttons[2].setButtonListener(this);
    buttons[3] = new Button((width / 4) - (buttonImgWidth / 2), (height - buttonImgHeight) / 2, buttonsImgs[5]);
    buttons[3].setButtonListener(this);
    
    img = loadImage("okfail.png");
    images = new PImage[3];
    images[0] = img.get(0, 0, 600, 350);
    images[1] = img.get(0, 350, 600, 350);
    images[2] = img.get(0, 700, 600, 350);
    init();
  }
  
  public void update() 
  {
    switch(currentStep) 
    {
      //Fading up
      case STEP_1:
      if(timer < FADING_TIME) 
      {
        timer += 1;
        alpha -= 5;
      }
      else 
      {
        timer = 0;
        currentStep = STEP_2;
      }
      break;
      
      //Wait
      case STEP_2:
      if(timer < INITIAL_WAIT_TIME) 
      {
        timer += 1;
      }
      else 
      {
        timer = 0;
        currentStep = STEP_3;
        audioManager.playRandomLoop();
      }
      break;
      
      //Show ready image
      case STEP_3:
      if(timer < READY_IMG_TIME) 
      {
        timer += 1;
      }
      else 
      {
        timer = 0;
        currentStep = STEP_4;
      }
      break;
      
      //Add a new key to sequence
      case STEP_4:
      keys.add(new Key());
      iKey = 0;
      nKeys = keys.size();
      showingSequence = true;
      keyTimer = 0;
      currentStep = STEP_5;
      break;
      
      //Show sequence
      case STEP_5:
      if(timer < FADING_TIME) 
      {
        timer += 1;
      }
      else 
      {
        if(showingSequence) 
        {
          if(keyTimer < keyTimerPace) 
          {
            keyValue = keys.get(iKey).value;
            if(keyTimer == 0) 
            {
              buttons[keyValue - 1].setCurrentState(Button.HAND_HOVER);
              audioManager.play(keyValue - 1);
            }
            else 
            {
              buttons[keyValue - 1].setCurrentState(Button.HAND_OFF);
            }
            keyTimer += 1;
          }
          else 
          {
            keyTimer = 0;
            iKey += 1;
            showingSequence = (iKey < nKeys);
          }
        }
        else 
        {
          keyTimer = 0;
          iKey = 0;
          isOk = true;
          showingSequence = true;
          buttons[0].setEnabled(true);
          buttons[1].setEnabled(true);
          buttons[2].setEnabled(true);
          buttons[3].setEnabled(true);
          timer = 0;
          currentStep = STEP_6;
        }
      }
      break;
      
      //Player's sequence
      case STEP_6:
      buttons[0].checkState();
      buttons[1].checkState();
      buttons[2].checkState();
      buttons[3].checkState();
      break;
      
      //Show Ok or Fail image
      case STEP_7:
      if(timer < OK_FAIL_TIME) 
      {
        timer += 1;
      }
      else 
      {
        if(lifes > 0) 
        {
          currentStep = (isOk) ? STEP_4 : STEP_5;
          timer = 0;
          iKey = 0;
        }
        else 
        {
          audioManager.stopLoop();
          viewManager.setCurrentView(ViewManager.GAMEOVER_VIEW);
        }
      }
      break;
    }
  }
  
  public void draw() 
  {
    background((currentStep == STEP_5) ? 0 : 255);
    buttons[0].draw();
    buttons[1].draw();
    buttons[2].draw();
    buttons[3].draw();
    
    if(currentStep == STEP_1) 
    {
      fill(0, alpha);
      rect(0, 0, width, height);
    }
    else if(currentStep == STEP_3) 
    {
      image(images[READY_IMG], (width - images[READY_IMG].width) / 2, (height - images[READY_IMG].height) / 2);
    }
    else if(currentStep == STEP_7) 
    {
      image(img, (width - img.width) / 2, (height - img.height) / 2);
    }
    
    if(currentStep != STEP_1 && currentStep != STEP_5) 
    {
      //Draw score
      image(scoreImg, 10, 10);
      scoreDigits = getDigits(score);
      n = scoreDigits.size();
      xPos = scoreImg.width + 10 - numberImgWidth;
      for(i = 0; i < n; i += 1) 
      {
        image(numbersImgs[scoreDigits.get(i).intValue()], xPos + (i + 1) * numberImgWidth, 10);
      }
      
      //Draw lifes
      image(lifesImg, halfWidth, 10);
      lifesDigits = getDigits(lifes);
      n = lifesDigits.size();
      xPos = halfWidth + lifesImg.width + 10 - numberImgWidth;
      for(i = 0; i < n; i += 1) 
      {
        image(numbersImgs[lifesDigits.get(i).intValue()], xPos + (i + 1) * numberImgWidth, 10);
      }
    }
    
  }
  
  private void init() 
  {
    timer = 0;
    lifes = 3;
    score = 0;
    alpha = 255;
    isOk = true;
    currentStep = STEP_1;
    keyTimerPace = MAX_KEY_TIME;
    keys = new ArrayList<Key>();
    buttons[0].setEnabled(false);
    buttons[1].setEnabled(false);
    buttons[2].setEnabled(false);
    buttons[3].setEnabled(false);
  }
  
  public void restart() 
  {
    init();
  }
  
  public void buttonDown(Button btn) 
  {
    if(btn == buttons[0]) 
    {
      audioManager.play(AudioManager.BEEP_1);
      buttonPressed = 1;
    }
    else if(btn == buttons[1]) 
    {
      audioManager.play(AudioManager.BEEP_2);
      buttonPressed = 2;
    }
    else if(btn == buttons[2]) 
    {
      audioManager.play(AudioManager.BEEP_3);
      buttonPressed = 3;
    }
    else if(btn == buttons[3]) 
    {
      audioManager.play(AudioManager.BEEP_4);
      buttonPressed = 4;
    }
    
    if(buttonPressed == keys.get(iKey).value) 
    {
      iKey += 1;
      
      //if the user successfully completes the sequence
      if(iKey == nKeys) 
      {
        //Add 1 to user's score
        score += 1;
        
        //Disable all buttons
        buttons[0].setEnabled(false);
        buttons[1].setEnabled(false);
        buttons[2].setEnabled(false);
        buttons[3].setEnabled(false);
        
        //Set image to be shown in STEP_7
        img = images[OK_IMG];
        
        //Gives 1 life to user if completed each 10 sequences
        if(nKeys % SEQUENCES_TO_EXTRA_LIFE == 0) 
        {
          lifes += 1;
        }
        
        //Reduce the key timer pace by 1 each 3 sequences
        if(nKeys % SEQUENCES_TO_REDUCE_PACE == 0) 
        {
          keyTimerPace = (keyTimerPace > MIN_KEY_TIME) ? keyTimerPace - 3 : MIN_KEY_TIME;
        }
        
        //Set last button to HAND_OFF state
        buttons[buttonPressed - 1].setCurrentState(Button.HAND_OFF);
        
        //Indicate to go to STEP_7
        currentStep = STEP_7;
      }
    }
    else 
    {
      //Indicate user failed
      isOk = false;
      
      //Disable all buttons
      buttons[0].setEnabled(false);
      buttons[1].setEnabled(false);
      buttons[2].setEnabled(false);
      buttons[3].setEnabled(false);
      
      //Set image to be shown in STEP_7
      img = images[FAIL_IMG];
      
      //User lost a life
      lifes -= 1;
      
      //Set last button to HAND_OFF state
      buttons[buttonPressed - 1].setCurrentState(Button.HAND_OFF);
      
      //Indicate to go to STEP_7
      currentStep = STEP_7;
      
      //Play fail sound
      audioManager.play(AudioManager.USER_FAIL);
    }
  }
  
  public void buttonOff(Button btn) 
  {
    //TODO
  }
  
  public void buttonHover(Button btn) 
  {
    //TODO
  }
  
  public int getScore() 
  {
    return score;
  }
  
  private ArrayList<Integer> getDigits(int n) 
  {
    ArrayList<Integer> digits = new ArrayList<Integer>();
    int digit;
    while(n / 10 != 0) 
    {
      digit = n % 10;
      digits.add(0, new Integer(digit));
      n /= 10;
    }
    digits.add(0, new Integer(n));
    return digits;
  }
  
}


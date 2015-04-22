
public class MenuView implements View, ButtonListener 
{
  
  public static final int STEP_1 = 0, STEP_2 = 1, STEP_3 = 2;
  private static final int FADING_TIME = 60;
  
  private ViewManager viewManager;
  private int timer;
  private int alpha;
  private int currentStep;
  
  private int selectedOption;
  private boolean checkHandEvents;
  
  private Button playBtn;
  
  private PImage leapSimonImg;
  private int leapSimonImgX;
  private int leapSimonImgY;
  
  public MenuView(ViewManager viewManager) 
  {
    this.viewManager = viewManager;
    leapSimonImg = loadImage("leapsimon.png");
    leapSimonImgX = (width - leapSimonImg.width) / 2;
    leapSimonImgY = 50;
    playBtn = new Button((width - buttonImgWidth) / 2, leapSimonImg.height + (buttonImgHeight / 2), buttonsImgs[0]);
    playBtn.setButtonListener(this);
    init();
  }
  
  public void update() 
  {
    switch(currentStep) 
    {
      case STEP_1:
      if(timer < FADING_TIME) 
      {
        timer += 1;
        alpha -= 5;
      }
      else 
      {
        playBtn.setEnabled(true);
        timer = 0;
        currentStep = STEP_2;
      }
      break;
      
      case STEP_2:
      playBtn.checkState();
      break;
      
      case STEP_3:
      if(timer < FADING_TIME) 
      {
        timer += 1;
        alpha += 5;
      }
      else 
      {
        viewManager.setCurrentView(ViewManager.SIMON_VIEW);
      }
      break;
    }
  }
  
  public void draw() 
  {
    background(255);
    image(leapSimonImg, leapSimonImgX, leapSimonImgY);
    playBtn.draw();
    fill(0, alpha);
    rect(0, 0, width, height);
  }
  
  private void init() 
  {
    timer = 0;
    alpha = 255;
    currentStep = STEP_1;
    checkHandEvents = false;
    playBtn.setEnabled(false);
  }
  
  public void restart() 
  {
    init();
  }
  
  public void buttonDown(Button btn) 
  {
    audioManager.play(AudioManager.BTN_CLICK);
    playBtn.setEnabled(false);
    currentStep = STEP_3;
  }
  
  public void buttonOff(Button btn) 
  {
    //TODO
  }
  
  public void buttonHover(Button btn) 
  {
    //TODO
  }
  
}


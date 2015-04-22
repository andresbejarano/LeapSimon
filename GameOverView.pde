
public class GameOverView implements View, ButtonListener 
{
  
  private static final int STEP_1 = 0, STEP_2 = 1, STEP_3 = 2;
  private static final int FADING_TIME = 60;
  private ViewManager viewManager;
  
  private PImage gameoverImg;
  private int gameoverImgWidth;
  private int gameoverImgHeight;
  
  private Button continueBtn;
  private int currentStep;
  private int timer;
  private int alpha;
  
  public GameOverView(ViewManager viewManager) 
  {
    this.viewManager = viewManager;
    gameoverImg = loadImage("gameover.png");
    gameoverImgWidth = gameoverImg.width;
    gameoverImgHeight = gameoverImg.height;
    continueBtn = new Button( (width - buttonImgWidth) / 2, height / 2, buttonsImgs[7]);
    continueBtn.setButtonListener(this);
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
        continueBtn.setEnabled(true);
        timer = 0;
        currentStep = STEP_2;
      }
      break;
      
      case STEP_2:
      continueBtn.checkState();
      break;
      
      case STEP_3:
      if(timer < FADING_TIME) 
      {
        timer += 1;
        alpha += 5;
      }
      else 
      {
        timer = 0;
        viewManager.setCurrentView(ViewManager.SIMON_VIEW);
      }
      break;
    }
    
  }
  
  public void draw() 
  {
    background(0);
    image(gameoverImg, 0, 0);
    fill(0, alpha);
    continueBtn.draw();
    rect(0, 0, width, height);
  }
  
  private void init() 
  {
    timer = 0;
    alpha = 255;
    currentStep = STEP_1;
    continueBtn.setEnabled(false);
  }
  
  public void restart() 
  {
    //TODO
  }
  
  public void buttonDown(Button btn) 
  {
    audioManager.play(AudioManager.BTN_CLICK);
    continueBtn.setEnabled(false);
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


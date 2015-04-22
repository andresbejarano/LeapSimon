
public class IntroView implements View 
{
  
  public static final int STEP_1 = 0, STEP_2 = 1, STEP_3 = 2;  
  private static final int FADING_TIME = 30, FULL_TIME = 60;
  private static final int BACKGROUND_COLOR = 0xff000000;
  
  private ViewManager viewManager;
  private int timer;
  private int alpha;
  private int currentStep;
  
  private PImage logo;
  private PVector logoLoc;
  
  public IntroView(ViewManager viewManager) 
  {
    this.viewManager = viewManager;
    logo = loadImage("logo.png");
    alpha = 0;
    currentStep = STEP_1;
    timer = 0;
    logoLoc = new PVector((width - logo.width) / 2, (height - logo.height) / 2);
  }
  
  public void update() 
  {
    switch(currentStep) 
    {
      case STEP_1:
      if(timer < FADING_TIME) 
      {
        timer += 1;
      }
      else 
      {
        if(alpha < 255) 
        {
          alpha += 15;
        }
        else 
        {
          timer = 0;
          currentStep = STEP_2;
        }
      }
      break;
      
      case STEP_2:
      if(timer < FULL_TIME) 
      {
        timer += 1;
      }
      else 
      {
        timer = 0;
        currentStep = STEP_3;
      }
      break;
      
      case STEP_3:
      if(alpha > 0) 
      {
        alpha -= 15;
      }
      else 
      {
        if(timer < FADING_TIME) 
        {
          timer += 1;
        }
        else 
        {
          viewManager.setCurrentView(ViewManager.MENU_VIEW);
        }
      }
      break;
      
      default:
      currentStep = STEP_1;
    }
  }
  
  public void draw() 
  {
    background(BACKGROUND_COLOR);
    tint(255, alpha);
    image(logo, logoLoc.x, logoLoc.y);
  }
  
  public void restart() 
  {
    currentStep = STEP_1;
    alpha = 0;
    timer = 0;
  }
  
}


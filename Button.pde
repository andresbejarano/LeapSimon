
public class Button 
{
  
  public static final int HAND_OFF = 0, HAND_HOVER = 1, HAND_DOWN = 2;
  public static final int HAND_OFF_COLOR = 0xffffff00, HAND_HOVER_COLOR = 0xff00ffff, HAND_DOWN_COLOR = 0xffff00ff;
  
  private int x;  //x left value of the button
  private int y;  //y top value of the button
  private int w;  //width of the button
  private int h;  //height of the button
  
  private int currentState = HAND_OFF;             //Current state of the button respecting the hand
  private int currentStateColor = HAND_OFF_COLOR;  //
  private int lastState = HAND_OFF;                //
  
  private PImage[] btnImages;  //Images for each button state
  
  private ButtonListener callback;
  
  private boolean enabled = true;
  
  public Button(int x, int y, PImage[] images) 
  {
    this.x = x;
    this.y = y;
    btnImages = images;
    w = btnImages[0].width;
    h = btnImages[0].height;
  }
  
  public void setButtonListener(ButtonListener listener) 
  {
    callback = listener;
  }
  
  public void draw() 
  {
    tint(255, 255);
    //fill(currentStateColor);
    image(btnImages[currentState], x, y);
  }
  
  public int getState() 
  {
    return currentState;
  }
  
  public void checkState() 
  {
    if(enabled && isHand) 
    {
      lastState = currentState;
      if(handLoc.x > x && handLoc.x < x + w && handLoc.y > y && handLoc.y < y + h) 
      {
        if(handLoc.z < pushThreshold) 
        {
          currentState = HAND_HOVER;
          currentStateColor = HAND_HOVER_COLOR;
          if(currentState != lastState) {
            callback.buttonHover(this);
          }
        }
        else 
        {
          currentState = HAND_DOWN;
          currentStateColor = HAND_DOWN_COLOR;
          if(currentState != lastState) 
          {
            callback.buttonDown(this);
          }
        }
      }
      else 
      {
        currentState = HAND_OFF;
        currentStateColor = HAND_OFF_COLOR;
        if(currentState != lastState) 
        {
          callback.buttonOff(this);
        }
      }
    }
    else 
    {
      currentState = HAND_OFF;
      currentStateColor = HAND_OFF_COLOR;
      if(currentState != lastState) 
      {
        callback.buttonOff(this);
      }
    }
  }
  
  public boolean isEnabled() 
  {
    return enabled;
  }
  
  public void setEnabled(boolean v) 
  {
    enabled = v;
  }
  
  public void setCurrentState(int s) 
  {
    currentState = s;
  }
  
}


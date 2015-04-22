
public class ViewManager 
{
  
  public static final int INTRO_VIEW = 0, MENU_VIEW = 1, TUTORIAL_VIEW = 2, SIMON_VIEW = 3, GAMEOVER_VIEW = 4;
  
  private View[] views;
  private int currentView = INTRO_VIEW;
  
  public ViewManager() 
  {
    views = new View[5];
    views[0] = new IntroView(this);
    views[1] = new MenuView(this);
    views[2] = new TutorialView(this);
    views[3] = new SimonView(this);
    views[4] = new GameOverView(this);
  }
  
  public void update() 
  {
    views[currentView].update();
  }
  
  public void draw() 
  {
    views[currentView].draw();
  }
  
  public void setCurrentView(int v) 
  {
    currentView = v;
    views[currentView].restart();
  }
  
  public int getCurrentView() 
  {
    return currentView;
  }
  
}

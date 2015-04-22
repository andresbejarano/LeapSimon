import ddf.minim.*;

public class AudioManager 
{
  
  public static final int BEEP_1 = 0, BEEP_2 = 1, BEEP_3 = 2, BEEP_4 = 3, BTN_CLICK = 4, USER_OK = 5, USER_FAIL = 6;
  
  private Minim minim;
  private AudioPlayer[] sounds;
  private AudioPlayer[] loops;
  private int currentLoop;
  private AudioPlayer background;
  
  private int nLoops = 22;
  
  public AudioManager(PApplet papplet) 
  {
    minim = new Minim(papplet);
    sounds = new AudioPlayer[7];
    sounds[0] = minim.loadFile("b1.mp3");
    sounds[1] = minim.loadFile("b2.mp3");
    sounds[2] = minim.loadFile("b3.mp3");
    sounds[3] = minim.loadFile("b4.mp3");
    sounds[4] = minim.loadFile("click.mp3");
    sounds[5] = minim.loadFile("b1.mp3");
    sounds[6] = minim.loadFile("fail.mp3");
    
    //Load background loops
    loops = new AudioPlayer[nLoops];
    for(int i = 0; i < nLoops; i += 1) 
    {
      loops[i] = minim.loadFile("loop" + (i + 1) + ".mp3");
    }
    
    //background = minim.loadFile("background.mp3");
  }
  
  public void play(int p) 
  {
    switch(p) 
    {
      case BEEP_1:    sounds[BEEP_1].play(0);    break;
      case BEEP_2:    sounds[BEEP_2].play(0);    break;
      case BEEP_3:    sounds[BEEP_3].play(0);    break;
      case BEEP_4:    sounds[BEEP_4].play(0);    break;
      case BTN_CLICK: sounds[BTN_CLICK].play(0); break;
      case USER_OK:   sounds[USER_OK].play(0);   break;
      case USER_FAIL: sounds[USER_FAIL].play(0); break;
    }
  }
  
  public void playLoop(int l) 
  {
    currentLoop = l;
    loops[currentLoop].loop();
  }
  
  public void playRandomLoop() 
  {
    currentLoop = (int)random(0, nLoops);
    loops[currentLoop].loop();
  }
  
  public void stopLoop() 
  {
    loops[currentLoop].pause();
  }
  
}


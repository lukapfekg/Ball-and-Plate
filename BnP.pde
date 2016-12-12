import processing.serial.*;
import processing.video.*;
PrintWriter output;

Serial port;
Capture cam;
Motor m1, m2;
Sistem S;

void setup() 
{

  m1= new Motor( 40, 90);
  m2= new Motor( 40, 90);

  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    //println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      //println(cameras[i]);
    }
    output = createWriter("positions.txt"); 
    // T5+he camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, "name=Eye 312,size=640x480,fps=35");
    cam.start();
  }      


  S = new Sistem();

  S.setCam(cam);


  //println(Serial.list());
  String portName = Serial.list()[0];
  port = new Serial(this, portName, 9600);
  m1.setPort(port);
  m2.setPort(port);

  fill(255, 0, 0);
}

void draw() {
  if (cam.available() == true) {    
    S.readCam();
    S.binarization();
    image(S.cam, 0, 0);
    S.centerOffMass();
    S.update();
    println(m1.ang + " " + m2.ang);
    point(mouseX, mouseY);
    if (m1.on ) output.print(S.e.mag()+"\t");
    m1.update();
    m2.update();

    noFill();
    line(0, height/2, width, height/2);
    line(width/2, 0, width/2, height);

    textSize(20);
    fill(255, 0, 0);
    textAlign(LEFT, TOP);
    text("Motori: ON: " + m1.on  + "\nPID:\nA " + S.pid.kp.x + "\nS " + S.pid.kd.x + "\nD " + S.pid.ki.x + "\nF " + S.pid.kp.y + "\nG " + S.pid.kd.y + "\nH " + S.pid.ki.y, 0, 0);
  }
}

boolean mouseOverRect(int x1, int y1, int x2, int y2) { 
  return ((S.cmass.x >= x1) && (S.cmass.x <= x2) && (S.cmass.y >= y1) && (S.cmass.y <= y2));
}

void keyPressed()
{
  if (key == 'q') {
    S.ei.mult(0);
    m1.turn();
    m2.turn();
  }
  if (key == 'f') output.flush();
  if (key == 'c') output.close();
  if (key == 'e') exit();
}

/*m1.ang=int(-(S.c.x-S.cmass.x)*180/640);
 m2.ang=int(-(S.c.y-S.cmass.y)*180/480);
 println(m1.ang+ "  "+m2.ang );
 m1.update();
 m2.update();
 println(m1.ang+ "  "+m2.ang );*/

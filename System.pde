class Sistem
{
  PID pid;

  PVector c, e, ei, ed, cmass, cornerTL, cornerBR;
  Capture cam;

  Sistem()
  {
    pid= new PID(0.04, 0.9, 0.0009, 0.0269, 0.588, 0.001);
    e = new PVector();
    ei = new PVector();
    ed = new PVector();
    c = new PVector(width/2, height/2);
    cmass = new PVector();
    int size = height-10;
    cornerTL = new PVector(width/2-size/2, height/2-size/2);
    cornerBR = new PVector(width/2+size/2, height/2+size/2);
  }

  void setCam(Capture cam)
  {
    this.cam = cam;
  }

  void readCam() {
    if (cam != null)
      cam.read();
  }

  void binarization()
  { 
    if (cam != null) {
      int threshold = 0;
      cam.loadPixels();
      /*
      for (int i = 1; i<cam.pixels.length; i++) threshold+=hue(cam.pixels[i]);
      threshold/=cam.pixels.length;
      for (int i = 1; i<cam.pixels.length; i++) if (inside(i)) cam.pixels[i]=color((abs(hue(cam.pixels[i])-180)<threshold*0.5 && brightness(cam.pixels[i])<90)?0:255);
      */
      //for (int i = 1; i<cam.pixels.length; i++) if (inside(i)) cam.pixels[i] = color(brightness(cam.pixels[i]));
      //for (int i = 1; i<cam.pixels.length; i++) if (inside(i)) cam.pixels[i] = color(abs(hue(cam.pixels[i])-180));
      for (int i = 1; i<cam.pixels.length; i++) if (inside(i)) cam.pixels[i] = color(saturation(cam.pixels[i]) < 110 ? 255:0);
      cam.updatePixels();
    } else {
      e.set(0, 0);
      ei.set(0, 0);
      ed.set(0, 0);
    }
  }

  void centerOffMass()
  {
    PVector sum = new PVector();
    cam.loadPixels();

    for (int i = 1; i<cam.pixels.length; i++) if (brightness(cam.pixels[i])<128 && inside(i)) {
      sum.x += i%width;
      sum.y += i/width;
      sum.z += 1;
    }
    
    if (sum.z == 0) cmass = new PVector(width/2, height/2);
    else {
      cmass.x = sum.x/sum.z;
      cmass.y = sum.y/sum.z;
    }
    
    println(cmass);

    fill(255, 0, 0);
    ellipse(cmass.x, cmass.y, 5, 5);
  }


  void update()
  {
    ed=PVector.sub(PVector.sub(cmass, c), e); 
    e=PVector.sub(cmass, c);
    ei.add(e);

    if (keyPressed) {
      float inc = 1.02;
      if (key=='a') pid.kp.x *= inc;
      if (key=='z') pid.kp.x /= inc;
      if (key=='s') pid.kd.x *= inc;
      if (key=='x') pid.kd.x /= inc;
      if (key=='d') pid.ki.x *= inc;
      if (key=='c') pid.ki.x /= inc;
      if (key=='f') pid.kp.y *= inc;
      if (key=='v') pid.kp.y /= inc;
      if (key=='g') pid.kd.y *= inc;
      if (key=='b') pid.kd.y /= inc;
      if (key=='h') pid.ki.y *= inc;
      if (key=='n') pid.ki.y /= inc;
    }

    pid.update(m1, m2, this);
  }

  boolean inside(int i) {
    if (i % width < cornerBR.x && i % width > cornerTL.x && i / width < cornerBR.y && i / width > cornerTL.y) return true;
    else return false;
  }
}


class Motor 
{
  boolean on;
  int ang, maxang, center;
  Serial port;

  Motor() 
  {
    ang = 130;
    
    on = false;
   
    setStartPos(90, 90);
  }

  Motor(int maxang_, int center_) 
  {
    ang = center_;
    on = false;
    
    setStartPos(maxang_, center_);
  }

  void setStartPos(int maxang_, int center_) {
    maxang = maxang_;
    center = center_;
  }
  
  void setPort(Serial port)
  {
    this.port = port;
  }

/*  void moove(int x)
  {
    ang+=x;
    if (ang < center-maxang) ang=center-maxang;
    if (ang > center+maxang) ang=center+maxang;
  }*/

  void update()
  {
    // println(ang);
    //moove(0);
    if (port != null) {
      if (!on ) ang = center;
      //ang = 180;
      port.write(ang);
    }
  }

  void turn() {
    on = !on;
  }
}


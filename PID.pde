class PID
{
  PVector kp, ki, kd;
  PVector mot;

  PID(float kpx, float kdx, float kix, float kpy, float kdy, float kiy)
  {
    kp = new PVector(kpx, kpy);
    kd = new PVector(kdx, kdy);
    ki = new PVector(kix, kiy);
  }

  void update(Motor m1, Motor m2, Sistem s)
  {
    if (true) {
      PVector p = new PVector(s.e.x, s.e.y);
      p.x *= kp.x;
      p.y *= kp.y;
      PVector i = new PVector(s.ei.x, s.ei.y);
      i.x *= ki.x;
      i.y *= ki.y;
      PVector d = new PVector(s.ed.x, s.ed.y);
      d.x *= kd.x;
      d.y *= kd.y;
      mot = PVector.add(PVector.add(p, i), d);
      m1.ang=-(int)mot.x+m1.center;
      m2.ang=(int)mot.y+m2.center;
    } else if (keyPressed) {
      int angdiff = 2;
      if (key == 'a') m1.ang-=angdiff;
      if (key == 'd') m1.ang+=angdiff;
      if (key == 'w') m2.ang+=angdiff;
      if (key == 's') m2.ang-=angdiff;
    }
  }
}
 

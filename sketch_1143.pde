class Line {

  Point p1;
  Point p2;
  String name;

  Line(Point p1, Point p2, String name) {
    this.p1=p1;
    this.p2=p2;
    this.name=name;
  }

  PVector getAtDistance(float distance) {
    PVector vect = p2.copy().sub(p1);
    vect.normalize();
    vect.mult(distance);
    return p1.copy().add(vect);
  }
  
  PVector vector(){
    return PVector.sub(p2, p1);
  }
  
  float length() {
    return p2.dist(p1);
  }

  float getA() {
    return (p2.y - p1.y) / (p2.x - p1.x + 0.01); // végtelen meredekségű cuccok esetére ne osszunk 0-val
  }

  float getB() {
    return p1.y - p1.x * getA();
  }

  Line perpendicularLineAtPoint(Point P) {
    return new Line(P, new Point(P.copy().add(1, -1/getA()), ""), "");
  }
  PVector intersection(Line other) {
    float a1 = getA();
    float b1 = getB();
    float a2 = other.getA();
    float b2 = other.getB();
    float x = (b1-b2) / (a2-a1 + 0.00001); // párhuzamos cuccok esetére ne osszunk 0-val
    float y = a2*x + b2;
    //println(other.getB());
    return new PVector(x, y);
  }

  Point intersection(Line other, String name) {
    PVector i = this.intersection(other);
    return new Point(i.x, i.y, name);
  }

  void draw() {
    stroke(0);
    strokeWeight(3);
    line(p1.x, p1.y, p2.x, p2.y);
    noStroke();
    fill(0);
    textSize(20);
    text(name, PVector.add(p1, p2).div(2).x, PVector.add(p1, p2).div(2).y);

    p1.draw();
    p2.draw();
  }

  void drawLight() {
    strokeWeight(1);
    stroke(128);
    line(p1.x, p1.y, p2.x, p2.y);
  }
}
class Point extends PVector {
  String name;
  public int pointSize=40;
  public int mColor = -1;

  Point(float x, float y, String name) {
    this.x=x;
    this.y=y;
    this.name=name;
  }

  Point(PVector p, String name) {
    this.x=p.x;
    this.y=p.y;
    this.name=name;
  }

  Point parse(PVector p, String name) {
    return new Point(p.x, p.y, name);
  }

  void drawLight() {
    fill(0);
    noStroke();
    ellipse(x, y, pointSize/4, pointSize/4);
  }

  void draw() {
    noStroke();
    if(mColor == -1) fill(10, 30, 255, 200);
    else fill(mColor);
    ellipse(x, y, pointSize/2, pointSize/2);
    if (dist(mouse)<=pointSize) {
      fill(10, 30, 255, 20);
      ellipse(x, y, pointSize, pointSize);
    }

    noStroke();

    
    textSize(20);
    fill(0);
    text(name, x+width/40, y+width/40);
    
    if (mousePressed && draggedPoint == null && dist(mouse) <= pointSize / 2) {
      draggedPoint = this;
    }
    if (draggedPoint == this) {
      this.x=mouse.x;
      this.y=mouse.y;
    }
  }
}

class Circle {
  Point o;
  float r;
  Circle(Point o, float r) {
    this.o=o;
    this.r=r;
  }

  void draw() {
    o.draw();
    strokeWeight(3);
    stroke(0);
    fill(0,0,255,10);
    ellipse(o.x, o.y, r*2, r*2);
  }

  void drawLight() {
    o.drawLight();
    strokeWeight(1);
    stroke(0);
    fill(0,0,255,10);
    ellipse(o.x, o.y, r*2, r*2);
  }

  ArrayList<Point> intersection(Line line) {
    float a = line.getA();
    float b = line.getB();
    println(a + " b: " + b);

    ArrayList<Point> points = new ArrayList<Point>();
    points.add(new Point(
      (- a*b + a*o.y + o.x + sqrt(r*r + a*a*r*r + 2*a*o.y*o.x + 2*b*o.y - a*a*o.x*o.x - 2*a*b*o.x - b*b - o.y*o.y)) / (a*a+1), 
      Float.NaN, // Majd behelyettesítjük
      "1"
      ));

    points.add(new Point(
      (- a * b + a * o.y + o.x + sqrt(r*r + a*a*r*r + 2*a*o.y*o.x + 2*b*o.y - a*a*o.x*o.x - 2*a*b*o.x - b*b - o.y*o.y)) / (a*a+1), 
      Float.NaN, // Majd behelyettesítjük
      "2"
      ));

    points.add(new Point(
      (- a * b + a * o.y + o.x - sqrt(r*r + a*a*r*r + 2*a*o.y*o.x + 2*b*o.y - a*a*o.x*o.x - 2*a*b*o.x - b*b - o.y*o.y)) / (a*a+1), 
      Float.NaN, // Majd behelyettesítjük
      "3"
      ));

    points.add(new Point(
      (- a * b + a * o.y + o.x - sqrt(r*r + a*a*r*r + 2*a*o.y*o.x + 2*b*o.y - a*a*o.x*o.x - 2*a*b*o.x - b*b - o.y*o.y)) / (a*a+1), 
      Float.NaN, // Majd behelyettesítjük
      "4"
      ));

    points.get(0).y = o.y + sqrt(r*r-pow(points.get(0).x - o.x, 2));
    points.get(1).y = o.y - sqrt(r*r-pow(points.get(0).x - o.x, 2));
    points.get(2).y = o.y + sqrt(r*r-pow(points.get(2).x - o.x, 2));
    points.get(3).y = o.y - sqrt(r*r-pow(points.get(2).x - o.x, 2));

    ArrayList<Point> result = new ArrayList<Point>();
    for (Point p : points) {
      if (!Float.isNaN(p.x) && !Float.isNaN(p.y)) {
        if (abs(a*p.x+b - p.y) <= 0.01) { // Ha a vonalon van
          result.add(p);
        }
      }
    }

    return result;
  }
}

Line e;
Line f;
Point P;
Line asd;

void setup() {
  //size(700, 700);
  fullScreen();
  e=new Line(new Point(width/10 * 2, height/10 * 2, "A"), new Point(width/10 * 5, height/10 * 3, "B"), "e");
  f=new Line(new Point(width/10 * 3, height/10 * 6, "C"), new Point(width/10 * 4, height/10 * 5, "D"), "f");
  P=new Point(2.5 * width/10, 2.5 * width/10, "P");
}

Point draggedPoint = null;

void mouseReleased() {
  draggedPoint=null;
}
PVector mouse=new PVector();

void draw() {
  mouse.x=mouseX;
  mouse.y=mouseY;

  background(255);


  Point I = e.intersection(f, "I");
  I.draw();
  Line e_ = new Line(I, e.p1, "e_");
  e_.drawLight();
  Line f_ = new Line(I, f.p1, "f_");
  f_.drawLight();
  float deltaDir = f_.vector().heading() - e_.vector().heading();
  Line h = new Line(I, new Point(I.x + cos(f_.vector().heading() + deltaDir) * 300, I.y + sin(f_.vector().heading() + deltaDir) * 300, "k"), "NEW");
  h.drawLight();
  Point G = new Point(e_.getAtDistance(100), "G");
  Point K = new Point(h.getAtDistance(100), "K");
  Line balMeroleges = e_.perpendicularLineAtPoint(G);
  Line jobbMeroleges = h.perpendicularLineAtPoint(K);
  Point korkozeppont = new Point(balMeroleges.intersection(jobbMeroleges), "O");

  Circle c1 = new Circle(korkozeppont, korkozeppont.dist(G));
  c1.drawLight();

  asd = new Line(I, P, "s");
  ArrayList<Point> ips = c1.intersection(asd);

  Line IO = new Line(I, c1.o, "IO");

  IO.drawLight();
  int i=0;
  for (Point p : ips) {
    i++;
    Line szogtartoSzakasz = new Line(p, c1.o, "sz" + i);
    Line ujSzogtartoSzakasz = new Line(P, new Point(szogtartoSzakasz.p2.copy().sub(szogtartoSzakasz.p1).add(P), "U"+i), "u"+i);

    Point O2 = IO.intersection(ujSzogtartoSzakasz, "O'" + i);
    Circle ci = new Circle(O2, e.perpendicularLineAtPoint(O2).intersection(e, "IE").dist(O2));
    ci.o.mColor = color(255,0,0,128);
    ci.draw();
    ujSzogtartoSzakasz.drawLight();
    szogtartoSzakasz.drawLight();
    p.drawLight();
  }

  asd.drawLight();
  e.draw();
  f.draw();
  P.draw();
  korkozeppont.draw();
  //d.drawLight();
  G.drawLight();
  K.drawLight();

  //println(e.intersection(f));

  //println(draggedPoint);
  //println(mouse);
}

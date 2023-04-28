class MineBlock {

  final color f = color(123, 227, 138);
  final color norm = color(173, 163, 121);
  final color normNotHidden = color(163, 146, 75);
  private int shim= 0;
  private int hD = 1;

  private ArrayList<MineBlock> neigh;
  boolean isHidden, isActive, isFlagged,exploded=false;
  int x, y, size;

  MineBlock(int x, int y, int size, boolean isActive) {
    this.x = x;
    this.y=y;
    this.size = size;
    this.isActive = isActive;
    isFlagged = false;
    isHidden = true;
    neigh = new ArrayList<MineBlock>();
  }


  void show() {
    strokeWeight(.5);
    stroke(150,100,50);
    fill(getColor());
    square(x, y, size);
    if (!isHidden && isActive){
      noStroke();
      fill(100,20,50);
      circle(x+(size/2),y+(size/2),size/2);
    }
      
    if (!isHidden && !hasExploded() && getNumN()>0 && !isFlagged) {
      showN();
    }
    isHover();
  }

  private void showN() {
    
    textSize(size-5);
    int numN = getNumN();
    stroke(0);
    fill(getC(numN));
    textAlign(CENTER);
    text(numN, x+(size/2), y+(size/1.2));
  }

  void isHover() {
    if (this.mouseInRange() && this.isHidden()) {
      fill(180+shim, 50+shim);
      square(x, y, size);
    }
  }

  void addN(MineBlock thisOne) {
    this.neigh.add(thisOne);
  }

  int getNumN() {
    int numN =0;
    for (int i=0; i< this.neigh.size(); i++)
      if (neigh.get(i).hasBomb())
        numN++;
    return numN;
  }

  boolean hasExploded() {
    return !isHidden && hasBomb();
  }

  boolean isFlagged() {
    return isFlagged;
  }
  boolean isHidden() {
    return isHidden;
  }
  boolean hasBomb() {
    return isActive;
  }

  void switchFlag() {
    isFlagged = !isFlagged;
  };
  
  void unHide(){isHidden = false;}
  
  void isClicked() {
    unHide();
    if(!isHidden && isActive)
      exploded=true;
    if (this.getNumN() == 0)
      indClick();
  }

  private void indClick() {
    for (MineBlock n : neigh)
      if (!n.hasBomb() && n.isHidden())
        n.isClicked();
  }

  boolean mouseInRange() {
    int endX = x+size;
    int endY = y+size;
    if(shim>50)
      hD*=-1;
    else if (shim<0)
      hD*=-1;
    shim+=hD;
    return mouseX>x && mouseX<endX && mouseY>y && mouseY<endY;
  }

  
  private color getColor() {
    color c;
    if (isFlagged)
      c = f;
    else if (isHidden)
      c = norm;
    else if(exploded)
      c = color(180,80,100);
    else
      c = normNotHidden;

    return c;
  }
  
  private color getC(int score){
    switch(score){
      case(0):
        return color(255);
      case(1):
        return color(111,232,93);
      case(2):
        return color(49,159,28);
      case(3):
        return color(233, 60, 61);
      case(4):
        return color(202, 128, 185);
      default:
        return color(random(255),random(255),random(255));
    }
  }
}

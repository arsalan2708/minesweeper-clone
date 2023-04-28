final int BLOCK_SIZE = 45;
final int ROWS = 15;
final int COLS = 20;

int MAX_BOMBS = (ROWS*COLS)/3;
int numBombs;
int startTime;
int currTime;

boolean gameOver; 

MineBlock [][] maze;


void settings() {
  size(BLOCK_SIZE*(COLS+1), BLOCK_SIZE*(ROWS+2));
  initMaze();
}

void draw() {
  
  background(0);
  gameLogic();
}


void mouseReleased() {
  if (!gameOver) {
    for (MineBlock [] row : maze) {
      for ( MineBlock block : row) {
        if (block.mouseInRange()) {
          if ((mouseButton == LEFT) && !block.isFlagged() )
            block.isClicked();
          else if ((mouseButton == RIGHT) && block.isHidden() )
            block.switchFlag();
        }
      }
    }
  }
}

void initMaze() {
  startTime = millis();
  currTime =0;
  gameOver = false;
  numBombs = (int)random(2, MAX_BOMBS);
  maze = new MineBlock[ROWS][COLS];
  int startHeight = BLOCK_SIZE/2;
  boolean hasBomb = false;
  int bmbs = numBombs;
  float p1, p2;

  for (int col = 0; col<COLS; col++) {
    p1 = random(1);
    for (int row = 0; row<ROWS; row++) {
      p2 = random(1)+p1;
      if ( p2<.65 && numBombs>0) {
        hasBomb = true;
        numBombs--;
      } else
        hasBomb = false;

      maze[row][col] = new MineBlock(startHeight+col*BLOCK_SIZE, startHeight+(row*BLOCK_SIZE), BLOCK_SIZE, hasBomb);
    }
  }
  assignN();
  println("BOMBS in Game: "+(bmbs-numBombs));
}

void assignN() {
  for (int col = 0; col<COLS; col++)
    for (int row = 0; row<ROWS; row++) {
      MineBlock b = maze[row][col];

      for (int c=col-1; c<col+2; c++) {
        for (int r=row-1; r<row+2; r++) {
          if (!(c<0 || r<0 || c>=COLS || r>=ROWS)) {
            if (c!=col || r!=row)
              b.addN(maze[r][c]);
          }
        }
      }
    }
}


void gameLogic(){
  boolean won = winCheck();
  boolean exp = bombWentOff();
  gameOver = won || exp;
  showMaze();
  if(won)
    showMsg("Congratulations");
  else if(exp)
    showMsg("You lost!");
  else
    showMsg("");
 if(gameOver)
   replay();
 countMines();
}


boolean winCheck(){
  boolean won = false;
  boolean isFilled = true;
  
  outerloop:
  for (MineBlock [] row : maze)
    for ( MineBlock block : row)
      if (!block.isFlagged() && block.isHidden() ) {
        isFilled = false;
        break outerloop;
      }
  if(isFilled){
    won = true;
    outerloop:
    for (MineBlock [] row : maze)
    for ( MineBlock block : row)
      if (block.isFlagged() && !block.hasBomb()) {
        won = false;
        break outerloop;
      }
  }
  
  return won;
}

boolean bombWentOff() {
  boolean hasExploded = false;
outerloop:
  for (MineBlock [] row : maze)
    for ( MineBlock block : row)
      if (block.hasExploded()) {
        hasExploded = true;
        break outerloop;
      }
  return hasExploded;
}

void showMaze() {
  for (MineBlock [] row : maze)
    for ( MineBlock block : row){
      if(gameOver && block.hasBomb())
        block.unHide();
      block.show();
    }
}

void countMines(){
 int currMines = 0;
 for(MineBlock [] row: maze)
   for(MineBlock block: row)
     if(block.isActive && !block.isFlagged())
       currMines++;
 
 String msg = String.format("BOMBS: %d",currMines);
 textSize(25);
 textAlign(LEFT);
 text(msg, 25, height-(BLOCK_SIZE/2));
 
}

void showMsg(String m) {
  String msg;
  fill(255);
  if(!gameOver){
    currTime = (millis() - startTime)/1000;
    msg = ""+currTime;
  }else 
    msg = m; 
  int fontSize = 25;
  textSize(fontSize);
  
  textAlign(CENTER);
  text(msg, width/2, height-(BLOCK_SIZE/2));
}

void replay(){
 fill(0,100);
 rect(0,0,width,height);
 String replay = "Replay";
 
 float x,y,hi,wid;
 wid= width/6;
 hi = wid/4;
 x= width-(wid*1.15);
 y=height-(hi*1.35);
 
 float fontSize = ((wid+hi)/1.5)/(replay.length());
 textSize(fontSize);
 
 fill(100,200,150);
 rect(x,y,wid,hi);
 fill(4,51,25);
 textAlign(CENTER);
 text(replay,x+(wid/2),y+(hi/1.5));
 
 if(mouseX>x && mouseX<x+wid && mouseY>y && mouseY<y+hi){
   fill(255,100);
   rect(x,y,wid,hi);
   if(mousePressed)
     initMaze();
 }
}

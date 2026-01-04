import de.bezier.guido.*;
int NUM_ROWS = 20, NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
    buttons = new MSButton[20][20];
    for(int c = 0; c < 20; c++) {
      for(int r = 0; r < 20; r++) {
        buttons[c][r] = new MSButton(r, c);
      }
    }
    setMines();
}
public void setMines()
{
  while(mines.size() < 80) {
    int randRow = (int) (Math.random()*20);
    int randCol = (int) (Math.random()*20);
    if(!(mines.contains(buttons[randCol][randRow]))) {mines.add(buttons[randCol][randRow]);}
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
  for(int i = 0; i < mines.size(); i++) {
    mines.get(i).clicked = false;
    mines.get(i).flagged = false;
  }
}
public void displayWinningMessage()
{
    //your code here
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {return true;}
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    if(isValid(row-1, col-1) && mines.contains(buttons[col-1][row-1])) {numMines++;}
    if(isValid(row, col-1) && mines.contains(buttons[col-1][row])) {numMines++;}
    if(isValid(row+1, col-1) && mines.contains(buttons[col-1][row+1])) {numMines++;}
    if(isValid(row-1, col) && mines.contains(buttons[col][row-1])) {numMines++;}
    if(isValid(row+1, col) && mines.contains(buttons[col][row+1])) {numMines++;}
    if(isValid(row-1, col+1) && mines.contains(buttons[col+1][row-1])) {numMines++;}
    if(isValid(row, col+1) && mines.contains(buttons[col+1][row])) {numMines++;}
    if(isValid(row+1, col+1) && mines.contains(buttons[col+1][row+1])) {numMines++;}
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
          flagged = !flagged;
          if(!flagged) {clicked = false;}
        } else if(mines.contains(this)) {
          displayLosingMessage();
        } else if(countMines(myRow, myCol) > 0) {
          setLabel(countMines(myRow, myCol));
        } else {
          if(isValid(myRow-1, myCol-1) && !buttons[myCol-1][myRow-1].clicked) {buttons[myCol-1][myRow-1].mousePressed();}
          if(isValid(myRow-1, myCol) && !buttons[myCol][myRow-1].clicked) {buttons[myCol][myRow-1].mousePressed();}
          if(isValid(myRow-1, myCol+1) && !buttons[myCol+1][myRow-1].clicked) {buttons[myCol+1][myRow-1].mousePressed();}
          if(isValid(myRow, myCol-1) && !buttons[myCol-1][myRow].clicked) {buttons[myCol-1][myRow].mousePressed();}
          if(isValid(myRow, myCol+1) && !buttons[myCol+1][myRow].clicked) {buttons[myCol+1][myRow].mousePressed();}
          if(isValid(myRow+1, myCol-1) && !buttons[myCol-1][myRow+1].clicked) {buttons[myCol-1][myRow+1].mousePressed();}
          if(isValid(myRow+1, myCol) && !buttons[myCol][myRow+1].clicked) {buttons[myCol][myRow+1].mousePressed();}
          if(isValid(myRow+1, myCol+1) && !buttons[myCol+1][myRow+1].clicked) {buttons[myCol+1][myRow+1].mousePressed();}
        }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}

import de.bezier.guido.*;
int NUM_ROWS = 20, NUM_COLS = 20, NUM_MINES = 80, clickedButtons = 0, startRow, startCol;
boolean ingame = false, lost = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(1000, 1000);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
    buttons = new MSButton[NUM_COLS][NUM_ROWS];
    for(int c = 0; c < NUM_COLS; c++) {
      for(int r = 0; r < NUM_ROWS; r++) {
        buttons[c][r] = new MSButton(r, c);
      }
    }
    clickedButtons = 0;
    mines.clear();
}
public void setMines()
{
  while(mines.size() < NUM_MINES) {
    int randRow = (int) (Math.random()*NUM_ROWS);
    int randCol = (int) (Math.random()*NUM_COLS);
    if(!(mines.contains(buttons[randCol][randRow])) && !buttons[randCol][randRow].clicked && !(Math.abs(randRow-startRow) <= 1 && Math.abs(randCol-startCol) <= 1)) {mines.add(buttons[randCol][randRow]);}
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true) {displayWinningMessage();}
    fill(0, 255, 0);
    clickedButtons = 0;
    for(int x = 0; x < buttons.length; x++) {
      for(int y = 0; y < buttons[x].length; y++) {
        if(buttons[x][y].clicked && !buttons[x][y].flagged && countMines(y, x) > 0 && !mines.contains(buttons[x][y])) {buttons[x][y].setLabel(countMines(y, x));}
        if(buttons[x][y].clicked && !buttons[x][y].flagged && !mines.contains(buttons[x][y])) {clickedButtons++;}
      }
    }
}
public boolean isWon()
{
    if(clickedButtons >= NUM_ROWS*NUM_COLS-NUM_MINES) {return true;}
    return false;
}
public void displayLosingMessage()
{
  ingame = false;
  lost = true;
  for(int i = 0; i < mines.size(); i++) {
    mines.get(i).clicked = true;
    mines.get(i).flagged = false;
    mines.get(i).setLabel(":(");
  }
}
public void displayWinningMessage()
{
  ingame = false;
  if(isWon()) {
    for(int i = 0; i < mines.size(); i++) {
      mines.get(i).setLabel(":)");
    }
  }
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
        width = 1000/NUM_COLS;
        height = 1000/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width+(500-(width*NUM_COLS/2));
        y = myRow*height+(500-(height*NUM_ROWS/2));
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(ingame) {
        if(mouseButton == RIGHT && ((!clicked) || flagged)) {
            clicked = true;
            flagged = !flagged;
            if(!flagged) {clicked = false;}
        } else if(mouseButton == LEFT && mines.contains(this) && !flagged) {
            clicked = true;
            displayLosingMessage();
        } else if(mouseButton == LEFT && countMines(myRow, myCol) > 0) {
            //if(!clicked) {clickedButtons++;}
            clicked = true;
            setLabel(countMines(myRow, myCol));
        } else if(mouseButton == LEFT) {
            //if(!clicked) {clickedButtons++;}
            clicked = true;
            if(isValid(myRow-1, myCol-1) && !buttons[myCol-1][myRow-1].clicked) {buttons[myCol-1][myRow-1].mousePressed();}
            if(isValid(myRow-1, myCol) && !buttons[myCol][myRow-1].clicked) {buttons[myCol][myRow-1].mousePressed();}
            if(isValid(myRow-1, myCol+1) && !buttons[myCol+1][myRow-1].clicked) {buttons[myCol+1][myRow-1].mousePressed();}
            if(isValid(myRow, myCol-1) && !buttons[myCol-1][myRow].clicked) {buttons[myCol-1][myRow].mousePressed();}
            if(isValid(myRow, myCol+1) && !buttons[myCol+1][myRow].clicked) {buttons[myCol+1][myRow].mousePressed();}
            if(isValid(myRow+1, myCol-1) && !buttons[myCol-1][myRow+1].clicked) {buttons[myCol-1][myRow+1].mousePressed();}
            if(isValid(myRow+1, myCol) && !buttons[myCol][myRow+1].clicked) {buttons[myCol][myRow+1].mousePressed();}
            if(isValid(myRow+1, myCol+1) && !buttons[myCol+1][myRow+1].clicked) {buttons[myCol+1][myRow+1].mousePressed();}
        }
      } else {
        if(!(clickedButtons >= NUM_ROWS*NUM_COLS-NUM_MINES || lost)) {
          if(mouseButton == LEFT) {
            if(clickedButtons == 0) {
              startRow = myRow;
              startCol = myCol;
            }
            while(mines.size() < NUM_MINES/2) {
              setGrid(3);
            }
            setMines();
            for(int x = 0; x < buttons.length; x++) {
              for(int y = 0; y < buttons.length; y++) {
                if(buttons[x][y].clicked && countMines(y, x) > 0) {
                  buttons[x][y].clicked = false;
                  buttons[x][y].setLabel("");
                }
              }
            }
            ingame = true;
            for(int x = 0; x < buttons.length; x++) {
              for(int y = 0; y < buttons[x].length; y++) {
                if(buttons[x][y].clicked && !buttons[x][y].flagged && countMines(y, x) == 0 && !mines.contains(buttons[x][y])) {buttons[x][y].mousePressed();}
              }
            }
          }
        } else {
          ingame = false;
          lost = false;
          setup();
        }
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
        text(mines.size(), 50, 50);
        text(clickedButtons, 100, 50);
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
    
    public void clickNeighbors(int level) {
      if(level > 0) {
        if(isValid(myRow-1, myCol-1) && !buttons[myCol-1][myRow-1].clicked && !mines.contains(buttons[myCol-1][myRow-1])) {buttons[myCol-1][myRow-1].setGrid(level-1);}
        if(isValid(myRow-1, myCol) && !buttons[myCol][myRow-1].clicked && !mines.contains(buttons[myCol][myRow-1])) {buttons[myCol][myRow-1].setGrid(level-1);}
        if(isValid(myRow-1, myCol+1) && !buttons[myCol+1][myRow-1].clicked && !mines.contains(buttons[myCol+1][myRow-1])) {buttons[myCol+1][myRow-1].setGrid(level-1);}
        if(isValid(myRow, myCol-1) && !buttons[myCol-1][myRow].clicked && !mines.contains(buttons[myCol-1][myRow])) {buttons[myCol-1][myRow].setGrid(level-1);}
        if(isValid(myRow, myCol+1) && !buttons[myCol+1][myRow].clicked && !mines.contains(buttons[myCol+1][myRow])) {buttons[myCol+1][myRow].setGrid(level-1);}
        if(isValid(myRow+1, myCol-1) && !buttons[myCol-1][myRow+1].clicked && !mines.contains(buttons[myCol-1][myRow+1])) {buttons[myCol-1][myRow+1].setGrid(level-1);}
        if(isValid(myRow+1, myCol) && !buttons[myCol][myRow+1].clicked && !mines.contains(buttons[myCol][myRow+1])) {buttons[myCol][myRow+1].setGrid(level-1);}
        if(isValid(myRow+1, myCol+1) && !buttons[myCol+1][myRow+1].clicked && !mines.contains(buttons[myCol+1][myRow+1])) {buttons[myCol+1][myRow+1].setGrid(level-1);}
      } else {
        if(isValid(myRow-1, myCol-1) && !buttons[myCol-1][myRow-1].clicked && !mines.contains(buttons[myCol-1][myRow-1])) {buttons[myCol-1][myRow-1].clicked = true;}
        if(isValid(myRow-1, myCol) && !buttons[myCol][myRow-1].clicked && !mines.contains(buttons[myCol][myRow-1])) {buttons[myCol][myRow-1].clicked = true;}
        if(isValid(myRow-1, myCol+1) && !buttons[myCol+1][myRow-1].clicked && !mines.contains(buttons[myCol+1][myRow-1])) {buttons[myCol+1][myRow-1].clicked = true;}
        if(isValid(myRow, myCol-1) && !buttons[myCol-1][myRow].clicked && !mines.contains(buttons[myCol-1][myRow])) {buttons[myCol-1][myRow].clicked = true;}
        if(isValid(myRow, myCol+1) && !buttons[myCol+1][myRow].clicked && !mines.contains(buttons[myCol+1][myRow])) {buttons[myCol+1][myRow].clicked = true;}
        if(isValid(myRow+1, myCol-1) && !buttons[myCol-1][myRow+1].clicked && !mines.contains(buttons[myCol-1][myRow+1])) {buttons[myCol-1][myRow+1].clicked = true;}
        if(isValid(myRow+1, myCol) && !buttons[myCol][myRow+1].clicked && !mines.contains(buttons[myCol][myRow+1])) {buttons[myCol][myRow+1].clicked = true;}
        if(isValid(myRow+1, myCol+1) && !buttons[myCol+1][myRow+1].clicked && !mines.contains(buttons[myCol+1][myRow+1])) {buttons[myCol+1][myRow+1].clicked = true;}
      }
    }
    
    
    public void setGrid(int level) {
      if(level == 0) {
          setMines();
      } else {
        clicked = true;
        int randRow = (int) (Math.random()*NUM_ROWS);
        int randCol = (int) (Math.random()*NUM_COLS);
        if(!(mines.contains(buttons[randCol][randRow])) && !(buttons[randCol][randRow].clicked) && mines.size() < NUM_MINES) {mines.add(buttons[randCol][randRow]);}
        randRow = (int) (Math.random()*NUM_ROWS);
        randCol = (int) (Math.random()*NUM_COLS);
        if(!(mines.contains(buttons[randCol][randRow])) && !(buttons[randCol][randRow].clicked) && mines.size() < NUM_MINES) {mines.add(buttons[randCol][randRow]);}
        for(int x = 0; x < buttons.length; x++) {
          for(int y = 0; y < buttons[x].length; y++) {
            if(buttons[x][y].clicked && countMines(y, x) > 0) {buttons[x][y].setLabel(countMines(y, x));}
          }
        }
        clickNeighbors(level);
      }
    }
}

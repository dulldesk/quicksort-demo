/*
4/17/2020
Quick Sort Visual Demonstration - this file draws the demonstration to the user. 
*/

// Colour values
final color GREEN = color(28, 191, 29);
final color BLUE = color(45, 112, 198);
final color RED = color(214, 70, 81);
final color YELLOW = color(241, 215, 137);
final color CYAN = color(80, 196, 209);

// Holds the code to be displayed
String [] rawCode;

// Whether the currently displayed array is sorted
boolean end = false;

// Whether the user is on the title slide
boolean onTitleSlide = true;
boolean next = true;

// Setup method
void setup() {
  // Window size
  size(830, 600);
  
  // A low frame rate is used to prevent the steps from going too quickly. Note that only every 5th frame is drawn, as implemented in draw().
  frameRate(9);
  
  // Load the steps into the deque 
  loadSteps(); 
  
  // Load the text file of the quick sort code
  rawCode = loadStrings("quick-sort-code.txt");
}

// If the key is pressed, then pause the program
void keyPressed() {
  noLoop();
  
  // If the user is not on the title slide, then redraw the information regarding pressing a key. 
  // As the loop is ceased, the information regarding whether a key is pressed will not update via draw(). 
  if (!onTitleSlide) keyInfo();
}

// If a key has been released, continue the program. 
void keyReleased() {
  loop();
  
  // If the sort was already finished, then start a new one.
  if (end) {
    end=false;
    loadSteps();
  }
}

// If the mouse was pressed, leave the title slide
void mousePressed() {
  onTitleSlide = false;
}

void draw() {
  // Only redraw the screen every 5th frame
  if (frameCount%5!=0) return;
  
  background(0);
  
  // If on the title slide, draw the title slide and nothing else
  if (onTitleSlide) {
    titleSlide();
    return;
  }
  // Information about quick sort
  sortInfo();
  
  // If there are still steps to be drawn
  if (!steps.isEmpty()) {
    // The current step
    BasicStep curr = steps.pollFirst();
    
    // Draw the code panel, highlighting the current line
    codePanel(curr.lne);
    
    if (curr.lne == 1) {
      // In essence, this is the first step of the sort. Make all elements cyan as all of them are to be sorted
      drawArr(curr.arr, CYAN);
    } else {
      if (curr instanceof PartStep) {
        // The current step is a partition method step
        PartStep prtcurr = (PartStep)curr;
        
        // Draw sort components
        markRange(curr.rngL, curr.rngR);
        drawArr(prtcurr);
        drawPivot(curr.pivot);
        drawLPtr(prtcurr.leftPtr);
        
        // If the step is not the swapping of the left pointer and the pivot, draw the right pointer
        if (prtcurr.rSwapInd != curr.pivot) drawRPtr(prtcurr.rgtPtr);
        
        if (prtcurr.onSwap()) {
          // The current step is a swap
          caption("swap left pointer,", 0);
          caption((prtcurr.rSwapInd == curr.pivot ? "pivot" : "right pointer"), 1);
        } else {
          // Vary the caption depending on what is currently happening to the left/right pointers
          if (prtcurr.pointerMvt() == 'L') {
            caption(curr.arr[prtcurr.leftPtr]+" <= "+curr.arr[curr.pivot], 0);
            caption("move left pointer", 1);
          } else if (prtcurr.pointerMvt() == 'R') {
            caption(curr.arr[prtcurr.rgtPtr]+" >= "+curr.arr[curr.pivot], 0);
            caption("move right pointer", 1);
          } else if (prtcurr.pointerMvt() == 'l') {
            caption(curr.arr[prtcurr.leftPtr]+" > "+curr.arr[curr.pivot], 0);
            caption("stop left pointer", 1);
          } else if (prtcurr.pointerMvt() == 'r') {
            caption(curr.arr[prtcurr.rgtPtr]+" < "+curr.arr[curr.pivot], 0);
            caption("stop right pointer", 1);
          } else if (prtcurr.pointerMvt() == 'c') {
            caption("pointers have crossed", 0);
            caption("stop right pointer", 1);
          }
        }
      } else {
        if (curr.onRangeSelect()) {
          // The current step is a range selectoin
          
          // Use cyan to indicate the elements to be sorted
          for (int i=0; i<N; i++) {
            if (curr.rngL <= i && i <= curr.rngR) drawNo(i, curr.arr[i], CYAN);
            else drawNo(i, curr.arr[i]);
          }
        } else {
          // Draw components
          drawArr(curr.arr);
          markRange(curr.rngL, curr.rngR);
          // It should be noted that the left and right pointers do not exist in this step
          
          if (curr.onPivotSelect()) {
            // Draw the pivot, if on a pivot selection step
            drawPivot(curr.pivot);
            caption("select pivot (R)", 0);
          }
        }
      }
    }
  } else { 
    // The array has been sorted
    // Draw a non-highlighted code panel and array
    end=true;
    codePanel();
    drawArr(arr);
  }
  //noLoop();
}

// Draw the current left pointer 
void drawLPtr(byte ind) {
  fill(255);
  rect(ind*40+30, 165, 5, 25);
  rect(ind*40+30, 185, 24, 5);
}

// Draw the current right pointer
void drawRPtr(byte ind) {
  fill(255);
  rect(ind*40+50, 165, 5, 25);
  rect(ind*40+30, 185, 24, 5);
}

// Given a label (either 'L' or 'R') and its index, draw the boundary of the range currently being sorted
void markRange(byte ind, char label) {
  fill(255);
  textSize(25);
  textAlign(CENTER);
  text(label, ind*40+45, 90);
}

// Draw the left and right boundaries of the range currently being sorted
void markRange(byte indL, byte indR) {
  markRange(indL, 'L');
  markRange(indR, 'R');
}

// Draw the pivot at a given index
void drawPivot(int ind) {
  fill(255);
  triangle(ind*40+45, 166, ind*40+40, 190, ind*40+50, 190);
}

// Given an array, draw its elements with the default colour
void drawArr(byte [] a) {
  for (int i=0; i<N; i++) drawNo(i, a[i]);
}

// Given an array, draw its elements with a given colour
void drawArr(byte [] a, color col) {
  for (int i=0; i<N; i++) drawNo(i, a[i], col);
}

// Draw the array, highlighting certain elements given the data of the step
void drawArr(PartStep sc) {
  for (int i=0; i<N; i++) {
    // Elements at the pointer indices or the index to be swapped are either green or yellow
    if (i == sc.leftPtr || i == sc.rgtPtr || i == sc.rSwapInd) {
      if (sc.onSwap() && (i == sc.rSwapInd || i == sc.leftPtr)) // elements to be swapped are green
        drawNo(i, sc.arr[i], GREEN);
      else drawNo(i, sc.arr[i], YELLOW); 
    } 
    else if (i == sc.pivot) drawNo(i, sc.arr[i], BLUE); // the pivot element is blue
    else drawNo(i, sc.arr[i]); // other elements are white
  }
}

// Draw an element of the array 
void drawNo(int ind, byte no, color col) {
  // box border
  stroke(255);
  fill(0, 0);
  rect(ind*40+25, 100, 40, 40);
  
  // number
  fill(col);
  textSize(25);
  textAlign(CENTER);
  text(no, ind*40+46, 130);
}

// Draw an element of the array with the default colour of white
void drawNo(int ind, byte no) {
  drawNo(ind, no, color(255));
}

// Draw the sort demo caption
void caption(String txt, color col, int row) {
  fill(col);
  textSize(30);
  textAlign(CENTER);
  text(txt, width/4, 300+row*40);
}

// Draw the sort demo caption with the default colour of white
void caption(String txt, int row) {
  caption(txt, color(255), row);
}

// Draw the code panel. 
// hl - the line of code to be highlighted. The argument is to be 1-indexed. 
void codePanel(int hl) {
  // Make the line of code 0-indexed. 
  hl-=1;
  
  // Draw the background panel
  fill(255);
  stroke(255);
  rect(width/2, 0, width/2, height);
  
  // Draw the lines of code
  textSize(15);
  textAlign(LEFT);
  
  // Loop through each line of code
  for (int i=0; i<rawCode.length; i++) {
    // If the code is to be highlighted, then use red text
    if (i==hl || (hl==7 && (i==8 || i==9))) fill(RED);
    else fill(0);
    
    // Draw the code. Replace '\t' with spaces as it will otherwise not show
    text(rawCode[i].replace("\u0009", "    "), width/2+20, i*24+50);
  }
  
  // If a negative code to highlight was indicated and the sort is not finished, then use a line. 
  if (hl < 0 && !end) {
    stroke(RED);
    float y = (abs(hl)-1.65)*24+50;
    line(width/2, y, width, y);
  }
  
  // Draw the information regarding key pressing
  keyInfo();
}

// Draw the code panel, but do not highlight any line
void codePanel() {
  codePanel(-1);
}

// Draw the information regarding key pressing
void keyInfo() {
  // Cover the old text. This is performed as in the keyPressed() method, draw() is not called (which would have erased the old text)
  fill(255);
  stroke(255);
  rect(width/2+20, height-50, width/2, 30);
  
  // Information
  fill(BLUE);
  textSize(25);
  textAlign(LEFT);
  if (end) text("Press any key to restart the sort", width/2+20, height-25);
  else if (keyPressed) text("Release to continue the sort", width/2+20, height-25);
  else text("Hold any key to pause the sort", width/2+20, height-25);
}

// Draw informatoin regarding the sort
void sortInfo() {
  fill(255);
  textAlign(LEFT);
  textSize(20);
  text("Time complexity: O(nlogn)", 20, 550);
  text("Worst case: O(n )", 20, 580);
  
  // Superscript 2
  textSize(10);
  text("2", 172, 572);
}

// The title slide
void titleSlide() {
  fill(255);
  textAlign(CENTER);
  
  textSize(70);
  text("Quick Sort Demo", width/2, height/2-30);
  
  textSize(25);
  text("Click anywhere to start", width/2, height/2+50);
  
  textAlign(RIGHT);
  textSize(15);
  text("Celeste Luo, 4/17/20", width-30, height-30);
}

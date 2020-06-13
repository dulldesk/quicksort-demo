/*
4/17/2020
Quick Sort Visual Demonstration - this file contains class declarations that are used to generate each step of the sort.
*/

// The BasicStep class contains data about a basic "step" taken in a quick sort.
class BasicStep {
  // The values in the array at this step 
  byte [] arr;

  // The index of the pivot
  byte pivot;

  // The leftmost index of the subarray being sorted in the current call
  byte rngL;

  // The rightmost index of the subarray being sorted in the current call
  byte rngR;

  // The line of code being executed
  byte lne;

  // A character representing the current step being taken
  char step;

  // BasicStep Constructor
  BasicStep(byte [] a, byte lr, byte rr, byte p, byte ln, char s) {
    arr = a;
    rngL = lr;
    rngR = rr;
    pivot = p;
    lne = ln;
    step = s;
  }

  // BasicStep Constructor
  BasicStep(byte [] a, byte lr, byte rr, byte p, byte ln) {
    arr = a;
    rngL = lr;
    rngR = rr;
    pivot = p;
    lne = ln;
    step = '-';
  }

  // Constructor. Initializes only the array and everything else to a default value. 
  BasicStep(byte [] a) {
    this(a, NEG1, NEG1, NEG1, (byte)1, '-');
  }

  // Returns whether the current step is the pivot selection
  boolean onPivotSelect() {
    return step == 'p';
  }

  // Returns whether the current step is the range selection
  boolean onRangeSelect() {
    return step == 'r';
  }
}

// The PartStep class, short for PartitionStep, contains data about a "step" taken in the partition method of a quick sort.
// It adds some components to the BasicStep class, hence why it extends it. 
class PartStep extends BasicStep {
  // The index of the current step's left pointer
  byte leftPtr;

  // The index of the current step's right pointer
  byte rgtPtr;

  // The rightmost index being swapped (the leftmost will always be the left pointer)
  byte rSwapInd;

  // PartStep object Constructor
  PartStep(byte [] a, byte l, byte r, byte p, byte lr, byte rr, byte ln, byte swpInd) {
    super(a, lr, rr, p, ln);
    leftPtr = l;
    rgtPtr = r;
    rSwapInd = swpInd;
  }

  // PartStep object Constructor
  PartStep(byte [] a, byte l, byte r, byte p, byte lr, byte rr, byte ln, char mvt) {
    super(a, lr, rr, p, ln, mvt);
    leftPtr = l;
    rgtPtr = r;
    rSwapInd = -1;
  }

  // Returns whether the current step is a swap
  boolean onSwap() {
    return rSwapInd != -1;
  }
  
  // Returns the current step. Any step called in this class will be about the movement of the pointer
  char pointerMvt() {
    return step;
  }
}

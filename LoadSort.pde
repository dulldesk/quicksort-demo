/*
4/17/2020
Quick Sort Visual Demonstration - this file generates each step of the sort and stores them into a deque.
*/

import java.util.Deque;
import java.util.LinkedList;

// Deque to hold each step. A deque is used as operations to peek the last element are needed. 
Deque<BasicStep> steps = new LinkedList<BasicStep>();

// The number of elements in the array
final byte N = 9;

// The value of negative 1 as a byte. Exists for easy access
final byte NEG1 = (byte)-1;

// The array of values
byte [] arr = new byte[N];
;

// Load all of the steps of the quick sort into the steps deque
void loadSteps() {
  // Fill array with random values
  for (byte i=0; i<N; i++) arr[i] = (byte)random(0, 100);

  // Add the first step: the original, unsorted array
  steps.add(new BasicStep(arr.clone()));

  // Initial call of the quicksort method. Sorts the array
  quickSort((byte)0, (byte)(N-1));
}

// Recursively sort the array and add each step to the deque of steps 
void quickSort(final byte L, final byte R) {
  // If the range is invalid, then do not sort it
  // Let a valid range be one where the leftmost index is less than or equal to the rightmost index
  // However, in this case, if the indices are overlapping, then there is nothing to sort, hence why it terminates the method call upon equal indices
  if (L>=R) return;

  // The pivot
  byte piv = arr[R];

  // The left pointer
  byte l=L;

  // The right pointer
  byte r=(byte)(R-1);

  // Step: the left pointer, right pointer, and pivot have been initialized. Add to the deque of steps
  steps.add(new PartStep(steps.peekLast().arr, l, r, R, L, R, (byte)8, NEG1));

  // Sometimes, steps.peekLast().arr is passed as an argument for the step, whereas other times, arr.clone() is passed
  // How one or the other is chosen is whether the array itself has been changed (clone it). Otherwise, the reference of the array at the previous step is taken to save memory as the arrays are the same regardless.  

  // While the range between the left and right pointer is valid, continue checking for a need to swap
  while (true) {
    // Move the left pointer until the value at its index is greater than the pivot or until the range between it and the right pointer is invalid
    while (arr[l]<=piv && l<=r && l<N-1) {
      // Step: move the left pointer. Add to the deque of steps
      steps.add(new PartStep(steps.peekLast().arr, l, r, R, L, R, (byte)12, 'L'));
      l++;
    }
    // Only consider the movement of the right pointer if the range between it and the left pointer is invalid
    if (l <= r) {
      // Step: stop the left pointer. Add to the deque of steps
      // This step is not added if the pointer range is invalid as that is considered a "pointer crossing", which is its own step below
      steps.add(new PartStep(steps.peekLast().arr, l, r, R, L, R, (byte)-12, 'l'));

      // Move the left pointer until the value at its index is less than the pivot or until the range between it and the right pointer is invalid
      while (piv<=arr[r] && l<=r && r>0) {
        // Step: move the right pointer. Add to the deque of steps
        steps.add(new PartStep(steps.peekLast().arr, l, r, R, L, R, (byte)13, 'R'));
        r--;
      }
    }

    // If the pointers have crossed (and thus rendered an invalid range between them), then cease the loop 
    if (l>=r) {
      // Step: pointers have crossed. Add to the deque of steps
      steps.add(new PartStep(steps.peekLast().arr, l, r, R, L, R, (byte)14, 'c'));
      break;
    } else {
      // Swap the values at the two pointers

      // Step: stop the right pointer. Add to the deque of steps
      steps.add(new PartStep(steps.peekLast().arr, l, r, R, L, R, (byte)-13, 'r'));

      // Step: prepare to swap the two pointers. Add to the deque of steps
      steps.add(new PartStep(steps.peekLast().arr, l, r, R, L, R, (byte)15, r));

      // Swap the values at the two pointers
      swap(l, r);

      // Step: the values at the two pointers have been swapped. Add to the deque of steps
      steps.add(new PartStep(arr.clone(), l, r, R, L, R, (byte)15, r));
    }
  }

  // Step: prepare to swap the left pointer and the pivot. Add to the deque of steps
  steps.add(new PartStep(steps.peekLast().arr, l, l, R, L, R, (byte)17, R));

  // Swap the values at the left pointer and the pivot
  swap(l, R);


  // Step: the values at the left pointer and the pivot have been swapped. Add to the deque of steps
  steps.add(new PartStep(arr.clone(), l, l, R, L, R, (byte)17, R));

  // Reassign the pivot value to the left pointer. This is used to split the current (sub)array into two subarrays, each which will be sorted
  piv = l;

  // If statements to determine whether the to-be-sorted subarray range is valid
  if (L<piv-1) {
    // Step: call the next range to be sorted. Add to deque of steps
    steps.add(new BasicStep(steps.peekLast().arr, L, (byte)(piv-1), R, (byte)4, 'r'));

    // Recursively sort the left subarray
    quickSort(L, (byte)(piv-1));
  }
  if (piv+1<R) {
    // Step: call the next range to be sorted. Add to deque of steps
    steps.add(new BasicStep(steps.peekLast().arr, (byte)(piv+1), R, R, (byte)5, 'r'));

    // Recursively sort the right subarray
    quickSort((byte)(piv+1), R);
  }
}

// Given two indices of the array, swap the values at them
void swap(byte a, byte b) {
  byte tmp = arr[a];
  arr[a] = arr[b];
  arr[b] = tmp;
}

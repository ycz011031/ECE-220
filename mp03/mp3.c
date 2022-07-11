#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  int row;

  printf("Enter a row index: ");
  scanf("%d",&row);

  // Write your code here
  //netid yz69
  //this program uses the function given to calculate the coefficient
  //the function is achieved by a while main loop and a for loop for the formula
  //the increment for "col" is a result for a bug fix
  int col=0;
  unsigned long num;
  while (col <= row) {
      int i;
      num=1;
    for ( i = 1; i <= col; ++i) {
        num = num*(row+1-i)/i;
    }
    col = col+1;
    printf("%lu ",num);
  }

  return 0;
}
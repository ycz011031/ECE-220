/*
 * countLiveNeighbor
 * Inputs:
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * row: the row of the cell that needs to count alive neighbors.
 * col: the col of the cell that needs to count alive neighbors.
 * Output:
 * return the number of alive neighbors. There are at most eight neighbors.
 * Pay attention for the edge and corner cells, they have less neighbors.
 */

int countLiveNeighbor(int* board, int boardRowSize, int boardColSize, int row, int col){
    int i,j;
    int cnt=0;
    for (i=row-1;i<=row+1;i++){
        if(i>=0 && i<boardRowSize){
            for (j=col-1;j<=col+1;j++){
                if(j>=0 && j<boardColSize){
                    if(board[i*boardColSize+j]==1 && (i*boardColSize+j != row*boardColSize+col)){
                        cnt = cnt +1 ;
                    }
                }
            }
        }

    }
    return cnt;
}


/*
 * Update the game board to the next step.
 * Input: 
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: board is updated with new values for next step.
 */
void updateBoard(int* board, int boardRowSize, int boardColSize) {
    int a;
    int b;
    int index;
    int updatedBoard[boardColSize*boardRowSize];
    for (a=0;a<boardRowSize;a++){
        for (b=0;b<boardColSize;b++){
            index= a*boardColSize+b;
            if (countLiveNeighbor(board,boardRowSize,boardColSize,a,b)==3){
                updatedBoard[index] = 1;
            }
            else if (countLiveNeighbor(board,boardRowSize,boardColSize,a,b)==2 && board[index]==1 ){
                updatedBoard[index] = 1;
            }
            else{
                updatedBoard[index] = 0;
            }
        }

    }

    int l;
    for (l=0;l < boardColSize*boardRowSize; l++){
        board[l]=updatedBoard[l];
    }
}

/*
 * aliveStable
 * Checks if the alive cells stay the same for next step
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: return 1 if the alive cells for next step is exactly the same with 
 * current step or there is no alive cells at all.
 * return 0 if the alive cells change for the next step.
 */ 
int aliveStable(int* board, int boardRowSize, int boardColSize){
    int x ;
    int y ;
    int stcheck;
    for (x=0;x<boardRowSize;x++){
        for (y=0;y<boardColSize;y++){
            stcheck = countLiveNeighbor(board,boardRowSize,boardColSize,x,y);
            if ((stcheck < 2 || stcheck >3) && board[x*boardColSize+y]){
                return 0;
            }

        }
    }
    return 1;

}

				
				
			


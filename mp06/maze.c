#include <stdio.h>
#include <stdlib.h>
#include "maze.h"


/*
 * createMaze -- Creates and fills a maze structure from the given file
 * INPUTS:       fileName - character array containing the name of the maze file
 * OUTPUTS:      None 
 * RETURN:       A filled maze structure that represents the contents of the input file
 * SIDE EFFECTS: None
 */
maze_t * createMaze(char * fileName)
{
    int rows,cols,x,y,z;
    FILE*file = fopen(fileName,"r");//opens the text file in reading mode
    fscanf (file,"%d",&cols);//scan the width of the maze(num of cols)
    fscanf (file,"%d",&rows);//scan the height of the maze(num of rows)
    //allocating memory for cells
    maze_t * maze = (maze_t*)malloc(sizeof(maze_t));
    maze->cells = calloc(rows,sizeof(char*));//allocates space for pointer of each column
    // allocating space for each column
    for (x=0;x<rows;x++){
        maze->cells[x]=calloc(cols,sizeof(char));

    }
    //setting width and height
    maze->height = rows;
    maze->width = cols;
    //getting data from file
    char temp;
    //finding out where S & E are and storing temp in to cells
    for (y=0;y<rows+1;y++){
        for (z=0;z<cols+1;z++){
            fscanf(file,"%c",&temp);
            if (temp != '\n') {
                maze -> cells[y][z] = temp;
            }
        

            if (temp == 'S'){
                maze->startRow = y;
                maze->startColumn = z;
            }
            if (temp == 'E'){
                maze->endRow = y;
                maze->endColumn = z;
            }
        }
    }


    


    


    // Your code here. Make sure to replace following line with your own code.
    return maze;
}

/*
 * destroyMaze -- Frees all memory associated with the maze structure, including the structure itself
 * INPUTS:        maze -- pointer to maze structure that contains all necessary information 
 * OUTPUTS:       None
 * RETURN:        None
 * SIDE EFFECTS:  All memory that has been allocated for the maze is freed
 */

//in this function i basically reversed the allocation process in the previous function
void destroyMaze(maze_t * maze)
{
    int i,j;
    j = maze->height;
    for (i=0; i<j;i++){
        free(maze->cells[i]);
    }
    free(maze->cells);
    free(maze); 
    // Your code here.
}

/*
 * printMaze --  Prints out the maze in a human readable format (should look like examples)
 * INPUTS:       maze -- pointer to maze structure that contains all necessary information 
 *               width -- width of the maze
 *               height -- height of the maze
 * OUTPUTS:      None
 * RETURN:       None
 * SIDE EFFECTS: Prints the maze to the console
 */
void printMaze(maze_t * maze)
{
    int x,y,i,j;
    x=maze->height;
    y=maze->width;
    for (i=0;i<x;i++){
        for(j=0;j<y;j++){
            printf("%c",maze->cells[i][j]);
        }
        printf("\n");
    }
    
    // Your code here.
}

/*
 * solveMazeDFS -- recursively solves the maze using depth first search,
 * INPUTS:               maze -- pointer to maze structure with all necessary maze information
 *                       col -- the column of the cell currently beinging visited within the maze
 *                       row -- the row of the cell currently being visited within the maze
 * OUTPUTS:              None
 * RETURNS:              0 if the maze is unsolvable, 1 if it is solved
 * SIDE EFFECTS:         Marks maze cells as visited or part of the solution path
 */ 
int solveMazeDFS(maze_t * maze, int col, int row)
{
    if(col <0 || row <0 || col >= maze->width || row >= maze->height){
        return 0;
    }
    if(maze->cells[row][col] != ' ' && maze->cells[row][col] != 'S' && maze->cells[row][col] != 'E'){
        return 0;
    }
    if(maze->cells[row][col] == 'E'){
        return 1;
    }
    maze->cells[row][col] = '*';

    if (solveMazeDFS(maze,col-1,row)){
        return 1;
    }
    if (solveMazeDFS(maze,col+1,row)){
        return 1;
    }
    if (solveMazeDFS(maze,col,row-1)){
        return 1;
    }
    if (solveMazeDFS(maze,col,row+1)){
        return 1;
    }
    
    maze->cells[row][col] = '~';

    
    // Your code here. Make sure to replace following line with your own code.
    return 0;
}

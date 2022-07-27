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

 // in this program, four function are realized
 // first of which would read an input as txt file and extract the maze in it
 // second is given the pointer destroy every thing in the maze sturcutre
 // third is given a maze structure, print out the maze
 // is using recursive function find the solution for said maze

maze_t * createMaze(char * fileName)
{

    int rows,cols,x,y,z;

    FILE*file = fopen(fileName,"r");//opens the text file in reading mode
    fscanf (file,"%d",&cols);//scan the width of the maze(num of cols)
    fscanf (file,"%d\n",&rows);//scan the height of the maze(num of rows)
    //the line change charc caused me so much problem at the begining
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
    free(maze); //as you can see, i used the free function in reverse order of malloc funciton
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

// this is quite a simple function, 2 loops through the two indexes of a 2d array
// x,y are temp variable to hold rows and cols from previous funciton
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

// in this function i roughly followed the algraithem given by the mp insturction page
// slight modification was made in effert to debug
// although i can see some code can be more optimized, i don't want to change anything to avoid bugs


int solveMazeDFS(maze_t * maze, int col, int row)
{
    if(col <0 || row <0 || col >= maze->width || row >= maze->height){
        return 0;
    }
    //checking if input is out of bound
    if(maze->cells[row][col] != ' ' && maze->cells[row][col] != 'S' && maze->cells[row][col] != 'E'){
        return 0;
    }
    //checkigng if input is a wall
    if(maze->cells[row][col] == 'E'){
        return 1;
    }
    //checking if input is the end
    //i understand  that by placing this in front ' ' check would save a condition for said funciton

 	
    if(maze->cells[row][col] != 'S'){
        maze->cells[row][col] = '*';
    }  
    // to avoid 'S' to be overwritten


     
    // i am not 100% sure why this is the case
    //by swtiching around the checking order, i fix some bugs where a singel '*' would "leak" from S
    // but this code works so.....   
	
    if(solveMazeDFS(maze,col+1,row)){
        return 1;
    } 
    // check right cell    

    if(solveMazeDFS(maze,col,row+1)){
        return 1;
    }
     // check cell above   
	
    if(solveMazeDFS(maze,col-1,row)){
        return 1;
    } 
    // check cell below

    if(solveMazeDFS(maze,col,row-1)){
        return 1;
    } 
    // check cell left    

    if(maze->cells[row][col] != 'S'){
        maze->cells[row][col] = '~';
    }
    // same as before, preventing S to be overwritten.

    // Your code here. Make sure to replace following line with your own code.
    return 0;
}

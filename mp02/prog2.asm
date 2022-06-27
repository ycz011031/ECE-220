;netid : yz69
;
;the program under "Main" label is used for getting the input and decide whether to end the program for "=" condition
.ORIG x3000
MAIN
   GETC
   OUT
;check for "="
   LD R1,ASCIIEQUA    ;load in the ascii value for "="
   JSR NEGATIVE       
   ADD R2,R1,R0       ;adding the inputed value and the inverted ascii for "ii"
   BRZ EQUALDET       ;if the previous step returned zero, meaning a "=" is entered
   BRnzp EVALUATE     ;if a "=" is not entered jump to evaluate
EQUALDET
   LD R4,STACK_TOP    ;load in the current stack top
   LD R1,STACK_START  ;load in the stack start
   JSR NEGATIVE       
   ADD R4,R1,R4       ;adding the stack top and inverted stack top
   ADD R4,R4,#1       ;i don't know why, but this step is required for the program to function
   BRz SKIP7
   JSR INVALID        ;reaching this step means the stack more or less than 1 value
SKIP7
   JSR POP            
   ADD R3,R0,#0       ;loading the numerical value into r3 for print_hex function
   JSR PRINT_HEX


;this is a subroutine for printing "invalid expression" and halting the program
INVALID
   LEA R0, PRITINVAL
   PUTS
   HALT



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
;this part is directly coppied from mp1, some of the registers has been switched around to accomamdate the changes.
;in the line by line comment for the code, r3 is changed to r1, r4 is changed to r3, temp register is also changed
PRINT_HEX
   LD R4,COUNTDOWN     ; load in counter 4, for 16bit bi- 4bit hex conversion
BTHLP     
     AND R1,R1,#0        ; initializing R3 as the 1 bit hex holder
     ADD R3,R3,#0        ; setting cc for R2
     BRzp SKIP11          ;detecting if first digit of data is 1
     ADD R1,R1,#8        ;if the most significant bit for a 4bit bi is 1, convers to 8 in decimal
SKIP11
     ADD R3,R3,R3        ;left shifting R2 
     BRzp SKIP12          ;deteccting if the second digit of data is 1
     ADD R1,R1,#4        ;the second digit if 1 convers to 4 in decimal
SKIP12
     ADD R3,R3,R3        ;left shifting R2
     BRzp SKIP13          ;detecting if the third digit of data is 1
     ADD R1,R1,#2        ;the third digit if 1 convers to 2 in decimal
SKIP13
     ADD R3,R3,R3        ;left shifting r2
     BRzp SKIP14          ;detecting if the fourth digit of data is 1
     ADD R1,R1,#1        ;the fourth digit if 1 convers to 1 in decimal
SKIP14
     ADD R3,R3,R3        ;left shifting R2
     ADD R1,R1,#-10      ;combined with the following step to detect if the hex number is greater than 9
     BRn SKIP15
     LD R6,ASCII_offset_A ;load in offset of the difference between 0 and A minus 10
     ADD R1,R1,R6        ;load in the ascii value of the desired char minus ascii offset 0
SKIP15
     LD R6,ASCII_offset_0 ;load in the ascii value of 0+10 for R3 was subtracted by 10 in the previous step
     ADD R0,R1,R6        ; calculating the correct ascii value to be printed
     OUT 
     ADD R4,R4,#-1       ; decrementing counter
     BRp BTHLP           ; if counter greater than 1, loop back for the next 4bit
     HALT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;the evaluate program has two main part
;first of which is to check whether the input is a number under check num to translating num char from ascii to decimal
;second is the check if the input is one of "+" , "-" ,"/","*","^" using the same method for the "=" check
EVALUATE
    ST R7,SAVEEVR7 ; due to multiple subroutines is called during the excution of this one, a callee save of R7 is done here
    ADD R0,R0,#0   ; setting cc
; check space
    LD R1,ASCIISPAC ; 
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRz INPUT       ;

; check num 
    LD R1,ASCIIZERO ; checking if the ascii for input is lower than "0"
	JSR NEGATIVE    ;
	ADD R2,R0,R1    ;
	BRn SKIP1       ; if yes than skip to check operants
	LD R1,ASCIININE ; checking if the ascii for input is higher than "9"
	JSR NEGATIVE    ;
	ADD R2,R0,R1    ;
	BRp SKIP1       ; if yes than skip to check operants
; translating num char from ascii to decimal	
	LD R1,ASCIIZERO ; subtracting the ascii offset from the input
	JSR NEGATIVE    ;
	ADD R0,R1,R0    ;
	JSR PUSH        ;
	BRnzp INPUT     ; when push is done return to main
SKIP1
    ST R0,R0SAVE1   ; reaching this part means that the input is either an operant or invalid
	JSR POP         ; thus we pop twice and load each pop into r3 and r4
	ADD R4,R0,#0    ; beofre the operation begain we first save R0 as input ascii for futrue use
	JSR POP         ;
	ADD R3,R0,#0    ;
	LD R0,R0SAVE1   ;
	ADD R5,R5,#0    ;
	BRnz SKIP0      ; checking if R5 is 1
	JSR INVALID     ; if r5 is 1 then input is invalid
SKIP0
; check "+"
    LD R1,ASCIIPLUS ; the check oeprant funciton is same as check "="
	JSR NEGATIVE    ; when an operant is caught, we call for the respective calc function
	ADD R2,R1,R0    ; and when the subroutine is completed we call for push
	BRnp SKIP2      ; and return to main
	JSR PLUS        ;
	JSR PUSH        ;
	BRnzp INPUT     ; this is input instead of main due to changed structure for the program
; check "-"
SKIP2     
    LD R1,ASCIIMINU ; same as check "+"
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP3      ;
    JSR MIN         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP3
; check "*"
    LD R1,ASCIIMULT ; same as check "+"
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP4      ;
	JSR MUL         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP4
;check "/"
    LD R1,ASCIIDIVI ; same as check "+"
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP5      ;
	JSR DIV         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP5
; check "^"
    LD R1,ASCIIEXPO ; same as check "+"
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP6      ; reaching skip6 means that the input meaning that the input is either a num or operant
	JSR EXP         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP6
    JSR INVALID     ;thus the invalid subroutin is called

INPUT
     BRnzp MAIN  

SAVEEVR7 .BLKW #1    ;
R0SAVE1  .BLKW #1    ;
	
; this is a subroutine for inverting a value, mainly used in evaluate
NEGATIVE	
	NOT R1,R1       ;
	ADD R1,R1,#1    ;
	RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS	
;your code goes here
    ADD R0,R4,R3 ;
	RET	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN	
    NOT R4,R4    ;
	ADD R4,R4,#1 ;
	ADD R0,R3,R4 ;
	RET
;your code goes here
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL	
	AND R0,R0,#0 ;
LPMUL
    ADD R4,R4,#-1 ;
	BRn MULDONE   ;
	ADD R0,R3,R0  ;
	BRnzp LPMUL   ;
MULDONE
    RET	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
DIV	
   AND R0,R0,#0   ; this function is realized by subtracting R3 by R4
   NOT R4,R4      ; and r0 plus each time the subtraction happened
   ADD R4,R4,#1   ; until r3 reaches zero or negative
DIVLP
   ADD R3,R3,R4   ;
   BRn DIVDONE    ;
   ADD R0,R0,#1   ;
   BRnzp DIVLP    ;
DIVDONE
   RET	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXP
   ADD R0,R3,#0   ;this function is realized by creating an outer and inner loop
EXLP   
   ADD R2,R4,#-1  ;the inner loop is similer to the mult function
   BRnz EXD       ;each time the inner loop is reached, we set one of the operater as the result for previous looping
   ADD R5,R3,#0   ;the outer loop would stop onece the R4 is decrementted to 0
   ADD R2,R0,#0
MULP   
   ADD R6,R5,#-1
   BRnz MUD 
   ADD R0,R0,R2
   ADD R5,R5,#-1
   BRnzp MULP
MUD
   ADD R4,R4,#-1
   BRnzp EXLP
EXD
   RET

	
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACK_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;
ASCIIPLUS   .FILL X002B ;
ASCIIMULT   .FILL X002A ;
ASCIIMINU   .FILL X002D ;
ASCIIDIVI   .FILL X002F ;
ASCIIZERO   .FILL X0030 ;
ASCIININE   .FILL X0039 ;
ASCIISPAC   .FILL X0020 ;
ASCIIEQUA   .FILL x003D ;
ASCIIEXPO   .FILL #94   ;
ASCII_offset_A  .FILL X0007 ;
ASCII_offset_0  .FILL X003A ;
COUNTDOWN       .FILL X0004 ;
NEG_R7	.BLKW #1;
PRITINVAL   .STRINGZ "Invalid Expression"



.END

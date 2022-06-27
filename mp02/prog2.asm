;netid : yz69
;
;
.ORIG x3000
MAIN
   GETC
   OUT
;check for "="
   LD R1,ASCIIEQUA
   JSR NEGATIVE
   ADD R2,R1,R0
   BRZ EQUALDET   
   BRnzp EVALUATE
EQUALDET
   LD R4,STACK_TOP 
   LD R1,STACK_START
   JSR NEGATIVE
   ADD R4,R1,R4
   ADD R4,R4,#1 
   BRz SKIP7
   JSR INVALID
SKIP7
   JSR POP
   ADD R3,R0,#0
   JSR PRINT_HEX



INVALID
   LEA R0, PRITINVAL
   PUTS
   HALT



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
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
;
;
EVALUATE
    ST R7,SAVEEVR7 ;
    ADD R0,R0,#0   ;

;your code goes here
; check space
    LD R1,ASCIISPAC ;
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRz INPUT       ;

; check num 
    LD R1,ASCIIZERO ;
	JSR NEGATIVE    ;
	ADD R2,R0,R1    ;
	BRn SKIP1       ;
	LD R1,ASCIININE ;
	JSR NEGATIVE    ;
	ADD R2,R0,R1    ;
	BRp SKIP1       ;
; translating num char from ascii to decimal	
	LD R1,ASCIIZERO ;
	JSR NEGATIVE    ;
	ADD R0,R1,R0    ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP1
    ST R0,R0SAVE1
	JSR POP         ;
	ADD R4,R0,#0    ;
	JSR POP         ;
	ADD R3,R0,#0    ;
	LD R0,R0SAVE1   ;
	ADD R5,R5,#0    ;
	BRnz SKIP0      ;
	JSR INVALID     ;
SKIP0
; check "+"
    LD R1,ASCIIPLUS ;
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP2      ;
	JSR PLUS        ;
	JSR PUSH        ;
	BRnzp INPUT     ;
; check "-"
SKIP2     
    LD R1,ASCIIMINU ;
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP3      ;
    JSR MIN         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP3
; check "*"
    LD R1,ASCIIMULT ;
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP4      ;
	JSR MUL         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP4
;check "/"
    LD R1,ASCIIDIVI ;
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP5      ;
	JSR DIV         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP5
; check "^"
    LD R1,ASCIIEXPO ;
	JSR NEGATIVE    ;
	ADD R2,R1,R0    ;
	BRnp SKIP6
	JSR EXP         ;
	JSR PUSH        ;
	BRnzp INPUT     ;
SKIP6
    JSR INVALID

INPUT
     BRnzp MAIN  

SAVEEVR7 .BLKW #1    ;
R0SAVE1  .BLKW #1    ;
	
	
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
   AND R0,R0,#0   ;
   NOT R4,R4      ;
   ADD R4,R4,#1   ;
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
   ADD R0,R3,#0
EXLP   
   ADD R2,R4,#-1
   BRnz EXD
   ADD R5,R3,#0
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

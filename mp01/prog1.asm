;netid :yz69
; The code given to you here implements the histogram calculation that 
; we developed in class.  In programming video lecture, we will discuss 
;  how to prints a number in hexadecimal to the monitor.
;
; Your assignment for this program is to combine these two pieces of 
; code to print the histogram to the monitor.
;
; If you finish your program, 
;    ** Submit a working version to Gradescope  **



	.ORIG	x3000		; starting address is x3000


;
; Count the occurrences of each letter (A to Z) in an ASCII string 
; terminated by a NUL character.  Lower case and upper case should 
; be counted together, and a count also kept of all non-alphabetic 
; characters (not counting the terminal NUL).
;
; The string starts at x4000.
;
; The resulting histogram (which will NOT be initialized in advance) 
; should be stored starting at x3F00, with the non-alphabetic count 
; at x3F00, and the count for each letter in x3F01 (A) through x3F1A (Z).
;

; table of register use in this part of the code
;    R0 holds a pointer to the histogram (x3F00)
;    R1 holds a pointer to the current position in the string
;       and as the loop count during histogram initialization
;    R2 holds the current character being counted
;       and is also used to point to the histogram entry
;    R3 holds the additive inverse of ASCII '@' (xFFC0)
;    R4 holds the difference between ASCII '@' and 'Z' (xFFE6)
;    R5 holds the difference between ASCII '@' and '`' (xFFE0)
;    R6 is used as a temporary register
;

	LD R0,HIST_ADDR      	; point R0 to the start of the histogram
	
	; fill the histogram with zeroes 
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP		; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z         ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct histogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop


; my program contains 2 layers, the outer layers uses an incrementing counter/offset to iterate between bins and chars.
; the inner layers convers 16 bit binary to 4 bit hex, the inner layer have 4 cycle per data.
;table of registors:
;  R0,used for trap functions thus left unchanged until an out function is called
;  R1,used as counter & offset for incrementing char that is being displayed and as pointer offset for memory location
;  R2,primary registor that holds the 16bit binary data of num_of_char to be translated to 4 bit hex
;  R3,DR for the binary 4bit bi-1bit hex interpratation
;  R5,temp registor that holds predetermined values and offsets
;  R6,same as R5, temp registor that holds predetermined values and offsets


PRINT_HIST
     AND R1,R1,#0        ;initialize r1 to 0, as offset that count to 27
PHLOOP1
     LD R5,ASCII_offset  ; load the base offset for "@"  
     ADD R0,R1,R5        ; calculating the correct ascii value to be printed
     OUT                 ;
     LD R0,SPACE         ; load ascii value ot be printed
     OUT
     LD R6,HIST_ADDR     ; load in the pointer for the start of data
     ADD R6,R1,R6        ; load in the correct pointer for the memeory to be loaded
     LDR R2,R6,#0        ; load in memory content
     
;binary ot hex conversion
     LD R4,COUNTDOWN     ; load in counter 4, for 16bit bi- 4bit hex conversion
BTHLP     
     AND R3,R3,#0        ; initializing R3 as the 1 bit hex holder
     ADD R2,R2,#0        ; setting cc for R2
     BRzp SKIP1          ;detecting if first digit of data is 1
     ADD R3,R3,#8        ;if the most significant bit for a 4bit bi is 1, convers to 8 in decimal
SKIP1
     ADD R2,R2,R2        ;left shifting R2 
     BRzp SKIP2          ;deteccting if the second digit of data is 1
     ADD R3,R3,#4        ;the second digit if 1 convers to 4 in decimal
SKIP2
     ADD R2,R2,R2        ;left shifting R2
     BRzp SKIP3          ;detecting if the third digit of data is 1
     ADD R3,R3,#2        ;the third digit if 1 convers to 2 in decimal
SKIP3
     ADD R2,R2,R2        ;left shifting r2
     BRzp SKIP4          ;detecting if the fourth digit of data is 1
     ADD R3,R3,#1        ;the fourth digit if 1 convers to 1 in decimal
SKIP4
     ADD R2,R2,R2        ;left shifting R2
     ADD R3,R3,#-10      ;combined with the following step to detect if the hex number is greater than 9
     BRn SKIP5
     LD R5,ASCII_offset_A ;load in offset of the difference between 0 and A minus 10
     ADD R3,R3,R5        ;load in the ascii value of the desired char minus ascii offset 0
SKIP5
     LD R5,ASCII_offset_0 ;load in the ascii value of 0+10 for R3 was subtracted by 10 in the previous step
     ADD R0,R3,R5        ; calculating the correct ascii value to be printed
     OUT 
     ADD R4,R4,#-1       ; decrementing counter
     BRp BTHLP           ; if counter greater than 1, loop back for the next 4bit
; END OF BINARY TO HEX LOOP
     LD R0,LINESHIFT     ; shifting lines on monitor
     OUT
     ADD R1,R1,#1        ;incrementing counter and offset for next char
     ADD R5,R1,#-15      ;combined with next step subtracting counter by 27
     ADD R5,R5,#-12
     BRn PHLOOP1         ;detecting if all 27 char has been printed

     
      
     



; you will need to insert your code to print the histogram here

; do not forget to write a brief description of the approach/algorithm
; for your implementation, list registers used in this part of the code,
; and provide sufficient comments



DONE	HALT			; done


; the data needed by the program
NUM_BINS	.FILL #27	; 27 loop iterations
NEG_AT		.FILL xFFC0	; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6	; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0	; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00     ; histogram starting address
STR_START	.FILL x4000	; string starting address
ASCII_offset  .FILL X0040 ; 
ASCII_offset_A  .FILL X0007 ;
ASCII_offset_0  .FILL X003A ;
COUNTDOWN       .FILL X0004 ;
LINESHIFT       .FILL X000A ;
SPACE           .FILL X0020 ;
; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END

; AUTHOR: JOSEPH KANG
; PURPOSE: TO WRITE A PROGRAM THAT COPIES THE CONTENTS OF AN ARRAY TO AN AREA OF STATIC RAM AND SORT IT USING SHELL SORT
; INSTRUCTOR: DONALD EVANS
			

		AREA ShellSort, CODE, READONLY
			
destinationArray EQU 0x40000000
		
		ENTRY
                        LDR    r0,=sourceArray
                        LDR    r1,=destinationArray
                        MOV  r2,#arraySize
                        BL       copyArray
 
                        LDR    r0,=destinationArray
                        MOV   r1,#arraySize
                        BL       shellSort
stop                	B         stop

;==========================================================================================================================================
 
copyArray

;Address of source array passed in R0
;Address of destination array passed in R1
;Number of array elements passed in R2, R2 will serve as the counter

; first, decrement r2
		SUB r2, r2, #1
; then copy the content of r0 into r3 and post-increment by 4 (r3 is a temporary register)
		LDR r3, [r0], #4 ; DCD in code below tells us we're dealing with words, so post-increment by 8
; store the content of r3 into the address at r1 and post-increment by 4
		STR r3, [r1], #4
; compare r2 to 0
		CMP r2,#0
; branch if greater than 0 to copyArray
		BGE copyArray
                        
 
        MOV PC,LR    ;Return to calling subroutine   

;==========================================================================================================================================   
 
shellSort

;void ShellSort( int num[ ], int aSize) {
;Address of source array passed in R0
;Number of array elements passed in R1
						
; ( r0 = num[] and r1 = aSize )

;int temp; ( I am assigning r3 as temp )

;bool swapFlag = true;
	;store 0x01 into a register to use as the swapFlag (0x01 is "true")
	;let the register be r4
	MOV r4,#0x01
	
;int distance = aSize;
	;load aSize into distance (let r5 = distance)
	MOV r5,r1

;CHECK WHILE LOOP CONDITIONS:
;__________________________________________________________________________
	
; while( swapFlag || (distance > 1)) {
	;let condition 0x1 stand for "true"
	;compare swapFlag to 0x1
whileConditions
	CMP r4, #0x1
	;if true, branch to a "whileStatements"
	BEQ whileStatements
	;also compare distance to 1
	CMP r5, #1
	;if greater,branch to "whileStatements"
	BGT whileStatements
;if both conditions are false, then the program will return to calling subroutine, thus ending the while condition check

;//end while
	MOV PC,LR  ;Return to calling subroutine







;RUN WHILE LOOP COMMANDS:
;__________________________________________________________________________

;swapFlag = false; (here begins the contents of while loop)
whileStatements
	;set swapFlag to false (which is any value other than 0x1)
	MOV r4, #0xFFFFFFFF
	
;distance = (distance+1) / 2;
	;use a temporary register r10 in calculation of (distance+1) / 2
	ADD r10, r5,#0x1
	LSR r5, r10, #1 ;end of the initial statements in the while loop







;CHECK FOR LOOP CONDITIONS (FOR LOOP WITHIN THE WHILE LOOP):
;__________________________________________________________________________
	
;for (int i = 0; i < (aSize - distance); i++) { (begin for loop)

	;use r6 as i
	MOV r6, #0x0
for ;for loop conditions will be checked here
	;use r7 as temporary
	SUB r7, r1, r5
	;compare i < (aSize - distance)
	CMP r6, r7
	
;we've got to stop the for loop by branching to checking the conditions for the while loop
	BGT endFor ;jump over the for loop if i >= (aSize - distance)






;CHECK IF STATEMENT CONDITIONS:
;__________________________________________________________________________
	
;if (num[i + distance] < num[i]) { (begin if statement)
	;use r7, r8, r9, and r11 as temporary
	ADD r7, r6, r5 ; r7 = i + distance
	LSL r7, r7, #2 ; multiply by 4 because we're dealing with words
	LDR r8, [r0, r7] ; num[i + distance]
	LSL r11,r6,#2 ; same here, multiply by 4
	LDR r9, [r0, r11] ; num[i]
	CMP r8, r9 ; num[i + distance] < num[i]
	BLT ifStatement ; if num[i + distance] < num[i], branch to the ifStatement
	
	


	;branch to for to stop program flow from running into ifStatement
endIfBranch	
	ADD r6,r6,#1
	B for






;RUN IF STATEMENT COMMANDS:
;__________________________________________________________________________

	
ifStatement
;//Swap values at positions i+distance and i
;temp = num[i + distance];
	LDR r3, [r0,r7]
;num[i + distance] = num[i];
	STR r9, [r0,r7]
;num[i] = temp;
	STR r3, [r0,r11]
;swapFlag = true;	
	MOV r4,#0x1
; end if
	B endIfBranch






;END THE FOR LOOP
;__________________________________________________________________________

;} //end for
endFor
	B whileConditions

;==========================================================================================================================================   
 
arraySize       	EQU 20
sourceArray  	DCD -9,23,-100,675,2,98,13,-4,1000,23,5,234,45,67,12,-2,54,2,17,99
                        END      
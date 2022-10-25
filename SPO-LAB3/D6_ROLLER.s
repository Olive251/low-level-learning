;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;	D6 ROLLER
;	HAVING AN AUTOMATED DIGITAL DICE ROLLER FOR WARHAMMER40K IS THE INSPIRATION
;	USER INPUTS TOTAL NUMBER OF D6 THEY WISH TO ROLL
;	OUTPUT A LINE ACROSS THE SCREEN BETWEEN INPUT AREA AND WHERE DICE ROLLS WILL APPEAR
;	A "DICE" (SQUARE OBJECT) BOUNCES ACROSS THE SCREEN ONCE NUMBER INPUT IS COMPLETE
;	SQUARE OBJECT WITH THE RESULT OF EACH DICE ROLL IS DISPLAYED ON THE SCREEN
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; ROM routines
define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates

; Memory locations
define		INPUT		$2000
INIT:
    JSR SCINIT  	; initialize and clear the screen
    LDY #$00

CHAR:     
    LDA MSG,y
    BEQ DONE
    JSR CHROUT  	; put the characters on to the screen
    INY
    BNE CHAR	

GET_CHAR:
    LDA #$A0		; CODE FOR BLACK SPACE/CURSOR
	JSR CHROUT
	LDA #$83		; MOVES CURSOR LEFT ONE POSITION
	JSR CHROUT
        
	JSR CHRIN
	CMP #$00
	BEQ GET_CHAR

	CMP #13			; User presses enter to set input as complete... have been unable to make this function as desired
	BEQ FINISH_IN
	
	CMP #48		    ; COMP INPUT CHAR WITH 0
	BCC GET_CHAR	; ...IF LOWER THAN '0' THEN GET ANOTHER CHAR
	
	CMP #58		    ; COMP INPUT CHAR WITH 9 + 1
	BCS GET_CHAR	; ...IF HIGHER THAN 9 THEN GET ANOTHER CHAR
                    ; THE ABOVE TWO BLOCKS ENSURE THAT ONLY NUMBERS ARE ENTERED
                    ; ...USE AN ASCII CHARACTER TABLE REFERENCE TO ADJUST THESE INPUT PARAMETERS
	
	STA INPUT, x    ; Should be storing starting at memloc 2000, starts store at
	JSR CHROUT		; Displays char from keyboard input
	INX
	JMP CURSOR

CURSOR:
	LDA #$A0		; CODE FOR BLACK SPACE/CURSOR
	JSR CHROUT
	LDA #$83		; MOVES CURSOR LEFT ONE POSITION
	JSR CHROUT
	JMP GET_CHAR

DONE:     
	JMP GET_CHAR

FINISH_IN:
    LDX $00	
	LDA #13
	JSR CHROUT		

READBACK_1:			; OUTPUT NUMBER FROM USER INPUT
	LDA INPUT, x
	BEQ READBACK_2
	JSR CHROUT
	INX
	BNE READBACK_1
READBACK_2:			; OUTPUT MSG_FIN SO THAT SCREEN READS "X DICE SELECTED". (X BEING THE USER INPUT)
	LDA MSG_FIN, x
	BEQ CLRMEM1
	JSR CHROUT
	INX
	BNE READBACK_2

CLRMEM1:			; Implemented to prevent old input from remaining in memory and being displayed during readback_pt1
					; copy from <http://6502.org/source/general/clearmem.htm>

	LDA #$00        ; Set up zero value
    TAY             ; Initialize index pointer
CLRMEM2:
	STA INPUT,Y   	; Clear memory location
    INY             ; Advance index pointer
    DEX             ; Decrement counter
	BNE CLRMEM2     ; Not zero, continue checking
    RTS             ; Return

MSG:
	DCB "E","N","T","E","R",32,"N","U","M","B","E","R",32,"O","F",32,"D","I","C","E",32,"T","O",32,"R","O","L","L",".",".",".",00
MSG_FIN:
	DCB 32,"D","I","C","E",32,"S","E","L","E","C","T","E","D",00

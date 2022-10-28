;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;	D6 ROLLER
;	HAVING AN AUTOMATED DIGITAL DICE ROLLER FOR WARHAMMER40K IS THE INSPIRATION
;	USER INPUTS TOTAL NUMBER OF D6 THEY WISH TO ROLL
;	SYSTEM DISPLAY CONFIRMATION READBACK OF NUMBER OF DICE THEY SELECTED
;	USER ARROW KEYS THROUGH THEIR ROLLED DICE, EACH SCREEN DISPLAYING ONLY ONE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ROM routines
define		SCINIT				$ff81 ; initialize/clear screen
define		CHRIN				$ffcf ; input character from keyboard
define		CHROUT				$ffd2 ; output character to screen
define		SCREEN				$ffed ; get screen size
define		PLOT				$fff0 ; get/set cursor coordinates
; Memory locations
define		INPUT				$2000
define		ROLL_COUNT			$2010
define		ROLLS				$2020
define		GRAPHIC				$4000
;Variables
define		WIDTH				12
define		HEIGHT				12
define		ROLL_MAX			07
define		ROLL_MIN			01

INIT:
    JSR SCINIT  	; initialize and clear the screen
    LDY #$00

; GET USER SELECTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	

; READBACK USER INPUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
READBACK_1:			; OUTPUT NUMBER FROM USER INPUT
	LDA INPUT, x
	BEQ READBACK_2
	JSR CHROUT
	INX
	BNE READBACK_1	

READBACK_2:
	LDX $00

READBACK_3:			; OUTPUT MSG_FIN SO THAT SCREEN READS "X DICE SELECTED". (X BEING THE USER INPUT)
	LDA MSG_FIN, x
	BEQ ROLL_PREP
	JSR CHROUT
	INX
	BNE READBACK_3
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; ROLL DICE & DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;	TODO - RECONFIGUE TO SAVE THE FULL GRAPHIC IN POINTER INSTEAD OF ON-SCREEN, THEN ACESS AND PRINT GRAPHIC FROM POINTER
ROLL_PREP:
	LDY #00
	LDA INPUT
	STA ROLL_COUNT
	JMP ROLL_DICE

ROLL_DICE:	
	LDA $FE
	AND #7

	CMP #ROLL_MAX
	BCS ROLL_DICE

	CMP #ROLL_MIN
	BCC ROLL_DICE

	STA ROLLS
	JMP SET_GRAPHIC

SET_GRAPHIC:	; TODO - RESET THESE BRANCHES TO CORRECT LOAD

	LDA 

	LDA ROLLS
	CMP #01
	BEQ LOAD_D1
	CMP #02
	BEQ LOAD_D1
	CMP #03
	BEQ LOAD_D1
	CMP #04
	BEQ LOAD_D1
	CMP #05
	BEQ LOAD_D1
	CMP #06
	BEQ LOAD_D1

LOAD_D1:
LOAD_D2:
	
LOAD_D3:

LOAD_D4:

LOAD_D5:

LOAD_D6:

PRE_DISPLAY:
	LDA #$29	; create a pointer at $10
 	STA $10		;   which points to where
 	LDA #$03	;   the graphic should be drawn
 	STA $11
 
 	LDA #$00	; number of rows we've drawn
 	STA $12		;   is stored in $12

	LDX #$00	; index for data
 	LDY #$00	; index for screen colum 	
DISPLAY_GRAPHIC:

 	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


END:				; Implemented to prevent old input from remaining in memory and being displayed during readback_pt1
					; copy from <http://6502.org/source/general/clearmem.htm>
	BRK				; temp for viewing values at end of program before clearing mem
	LDA #$00        ; Set up zero value
    TAY             ; Initialize index pointer
CLRMEM:
	STA INPUT,Y   	; Clear memory location
    INY             ; Advance index pointer
    DEX             ; Decrement counter
	BNE CLRMEM     ; Not zero, continue checking
    BRK


; DISPLAY TEXT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
MSG:
	DCB "E","N","T","E","R",32,"N","U","M","B","E","R",32,"O","F",32,"D","I","C","E",32,"T","O",32,"R","O","L","L",".",".",".",00
MSG_FIN:
	DCB 32,"D","I","C","E",32,"S","E","L","E","C","T","E","D",00
; GRAPHICS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
d_1:          
dcb 04,04,04,04,04,04,04,04,04,04,04,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,04,04,00,00,00,00,04
dcb 04,00,00,00,00,04,04,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,04,04,04,04,04,04,04,04,04,04,04


d_2:
dcb 04,04,04,04,04,04,04,04,04,04,04,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,04,04,04,04,04,04,04,04,04,04,04

d_3:
dcb 04,04,04,04,04,04,04,04,04,04,04,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,04,04,00,00,00,00,04
dcb 04,00,00,00,00,04,04,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,04,04,04,04,04,04,04,04,04,04,04

d_4:
dcb 04,04,04,04,04,04,04,04,04,04,04,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,04,04,04,04,04,04,04,04,04,04,04

d_5:
dcb 04,04,04,04,04,04,04,04,04,04,04,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,00,00,00,04,04,00,00,00,00,04
dcb 04,00,00,00,00,04,04,00,00,00,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,04,04,04,04,04,04,04,04,04,04,04

d_6:
dcb 04,04,04,04,04,04,04,04,04,04,04,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,04,04,00,00,00,00,04,04,00,04
dcb 04,00,00,00,00,00,00,00,00,00,00,04
dcb 04,04,04,04,04,04,04,04,04,04,04,04
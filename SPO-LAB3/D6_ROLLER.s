;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;	Github: https://github.com/Olive251/6502_Learning/blob/master/SPO-LAB3/D6_ROLLER.s
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

; Memory locations		;add low and hi pointer for graphics
define 		TEMP_X				$100
define		TEMP_Y				$101
define		TEMP_A				$102

define		INPUT				$2000
define		ROLL_COUNT			$2005
define		ROLLS				$2010

define		SCREEN_PTR_LO		$10
define		SCREEN_PTR_HI		$11

define		GRAPHIC_PTR_LO		$40
define		GRAPHIC_PTR_HI		$41

;Variables
define		WIDTH				8
define		HEIGHT				8
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

	CMP #13			; User presses enter to set input as complete
	BEQ FINISH_IN
	
	CMP #48		    ; COMP INPUT CHAR WITH 0
	BCC GET_CHAR	; ...IF LOWER THAN '0' THEN GET ANOTHER CHAR
	
	CMP #58		    ; COMP INPUT CHAR WITH 9 + 1
	BCS GET_CHAR	; ...IF HIGHER THAN 9 THEN GET ANOTHER CHAR
	
	STA INPUT, x    
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

; ROLL DICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
	; JMP LOAD_GRAPHICS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; DISPLAY ROLLS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	; Use the roll to determine where to load graphic from/which graphic

load_graphics:
; starting conditions
; X = x position on the screen
; Y = y position on the screen
; A = graphic (0 or 1 or 2)


	LDA #$00 		; graphic selector
	LDX #$C
	LDY #$B

; convert A into a pointer to the graphics data

	STA TEMP_A		; save the values in the registers
	STY TEMP_Y
	STX TEMP_X

	LDA #$00		; start with 0 in the hi byte of the pointer
	STA SCREEN_PTR_HI

	; multiply the Y value by 256
	; ... low byte is in A	
	; ... high byte is in SCREEN_POINTER_HI
	TYA
	ASL
	ROL SCREEN_PTR_HI
	ASL
	ROL SCREEN_PTR_HI
	ASL
	ROL SCREEN_PTR_HI
	ASL
	ROL SCREEN_PTR_HI
	ASL
	ROL SCREEN_PTR_HI

	; add X to screen location
	; ... low byte gets stored to SCREEN_POINTER_LO
	; ... high byte still in SCREEN_POINTER_HI
	CLC
	ADC TEMP_X
	STA SCREEN_POINTER_LO
	LDA #$00
	ADC SCREEN_POINTER_HI
	STA SCREEN_POINTER_HI

	; add $0200 to the pointer
	; ... we skip the low byte because it's 00
	CLC
	LDA #$02
	ADC SCREEN_POINTER_HI
	STA SCREEN_POINTER_HI

 	LDA #$00	; number of rows we've drawn
 	STA $12		;   is stored in $12
 
 	LDX #$00	; index for data
 	LDY #$00	; index for screen column
 
	LDA TEMP_A
 
	ASL 
	ASL 
	ASL 
	ASL
	ASL
	ASL
	STA GRAPHIC_POINTER_LO
	LDA #>GRAPHICS
	STA GRAPHIC_POINTER_HI

draw_graphic:
	STY TEMP_Y
	TXA
	TAY
	LDA (GRAPHIC_POINTER_LO),y	; THROWS SYNTAX ERROR IN EMULATOR

	LDY TEMP_Y
	STA (SCREEN_POINTER_LO),y	; THROWS SYNTAX ERROR IN EMULATOR
	LDA #<GRAPHICS

	INX
	INY
	CPY #WIDTH
	BNE draw_graphic

	INC $12		; INCREMENTING ROW COUNTER

	LDA #HEIGHT	; CHECK IF COMPLETE
	CMP $12
	BEQ END

	LDA $10
	CLC
	ADC $20		; ADD 32 TO DROP A ROW
	STA $10
	LDA $11
	ADC #$00
	STA $11

	LDY #$00
	BEQ draw_graphic
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; CLEANUP >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
END:				; Implemented to prevent old input from remaining in memory and being displayed during readback_pt1
					; copied from <http://6502.org/source/general/clearmem.htm>
	BRK				; TODO- CLEAR AFTER TESTING ; temp for viewing values at end of program before clearing mem
	LDA #$00        ; Set up zero value
    TAY             ; Initialize index pointer
CLRMEM:
	STA INPUT,Y   	; Clear memory location
    INY             ; Advance index pointer
    DEX             ; Decrement counter
	BNE CLRMEM     ; Not zero, continue checking
    BRK
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; TEXT TO DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
MSG:
	DCB "E","N","T","E","R",32,"N","U","M","B","E","R",32,"O","F",32,"D","I","C","E",32,"T","O",32,"R","O","L","L",".",".",".",
	DCB "(","C","u","r","r","e","n","t","l","y",32,"c","a","n",32,"o","n","l","y",32,"r","o","l","l",32,"o","n","e",")",00
MSG_FIN:
	DCB 32,"D","I","C","E",32,"S","E","L","E","C","T","E","D",00

; GRAPHICS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*=$4000

GRAPHICS:
; D1
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,00,00,04,04,04
dcb 04,04,04,00,00,04,04,04
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
; D2
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,00,00,04
dcb 04,04,04,04,04,00,00,04
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
dcb 04,00,00,04,04,04,04,04
dcb 04,00,00,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
; D3
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,00,00,04
dcb 04,04,04,04,04,00,00,04
dcb 04,04,04,00,00,04,04,04
dcb 04,04,04,00,00,04,04,04
dcb 04,00,00,04,04,04,04,04
dcb 04,00,00,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
; D4
dcb 04,04,04,04,04,04,04,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,04,04,04,04,04,04,04
dcb 04,04,04,04,04,04,04,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,04,04,04,04,04,04,04
; D5
dcb 04,04,04,04,04,04,04,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,04,04,00,00,04,04,04
dcb 04,04,04,00,00,04,04,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,04,04,04,04,04,04,04
; D6
dcb 04,04,04,04,04,04,04,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,00,00,04,04,00,00,04
dcb 04,04,04,04,04,04,04,04
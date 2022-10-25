; ROM routines
define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates

	JSR SCINIT
	LDA #$A0	; CODE FOR BLACK SPACE/CURSOR
	JSR CHROUT
	LDA #$83	; MOVES CURSOR LEFT ONE POSITION
	JSR CHROUT
	

GET_CHAR:
	JSR CHRIN
	CMP #$00
	BEQ GET_CHAR
	
	CMP #48		    ; COMP INPUT CHAR WITH A
	BCC GET_CHAR	; ...IF LOWER THAN '0' THEN GET ANOTHER CHAR
	
	CMP #57		    ; COMP INPUT CHAR WITH 0 + 1
	BCS GET_CHAR	; ...IF HIGHER THAN 0 THEN GET ANOTHER CHAR
                    ; THE ABOVE TWO BLOCKS ENSURE THAT ONLY NUMBERS ARE ENTERED
                    ; ...FIND AN ASCII TABLE REFERENCE TO ADJUST THESE INPUT PARAMETERS
	
	JSR CHROUT

	LDA #$A0	; CODE FOR BLACK SPACE/CURSOR
	JSR CHROUT
	LDA #$83	; MOVES CURSOR LEFT ONE POSITION
	JSR CHROUT

	JMP GET_CHAR

    
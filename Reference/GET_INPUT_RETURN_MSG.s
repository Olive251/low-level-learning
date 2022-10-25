; ROM routines
define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates

    JSR SCINIT  ; initialize and clear the screen
    LDY #$00

CHAR:     
    LDA INST_MSG,y
    BEQ DONE
    JSR CHROUT  ; put the characters on to the screen
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

    CMP #$21


    LDA #$A0		; CODE FOR BLACK SPACE/CURSOR
	JSR CHROUT
	LDA #$83		; MOVES CURSOR LEFT ONE POSITION
	JSR CHROUT

SEND_SUCCESS:
    LDA SUCC_MSG, y
    JSR CHROUT
    INY
    BNE SEND_SUCCESS
    BRK

DONE:     
	JMP GET_CHAR

INST_MSG:
    DCB "T","Y","P","E",32,"'","!","'",00
SUCC_MSG:
    DCB "Y","O","U",32,"D","I","D",32,"I","T","!",00
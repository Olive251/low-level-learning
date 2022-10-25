; ROM routines
define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates

          jsr SCINIT  ; initialize and clear the screen
          ldy #$00

char:     lda text,y
          beq char2
          jsr CHROUT  ; put the character in A on to the screen
          iny
          bne char
char2:
        lda text2, Y
        beq done
        jsr CHROUT
        iny
        bne char2

done:     brk

text:
dcb "E","N","T","E","R",
text2:
dcb 32,"N","A","M","E"
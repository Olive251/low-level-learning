define WIDTH 	12 ; width of graphic
define HEIGHT 	12 ; height of graphic 
 
 	lda #$29	; create a pointer at $10
 	sta $10		;   which points to where
 	lda #$03	;   the graphic should be drawn
 	sta $11
 
 	lda #$00	; number of rows we've drawn
 	sta $12		;   is stored in $12
 
 	ldx #$00	; index for data
 	ldy #$00	; index for screen column

SELECT_DICE_SPRITE:
	LDA ROLLS

	CMP #01
	BEQ DISPLAY_D1
	CMP #02
	BEQ DISPLAY_D2
	CMP #03
	BEQ DISPLAY_D3
	CMP #04
	BEQ DISPLAY_D4
	CMP #05
	BEQ DISPLAY_D5
	CMP #06
	BEQ DISPLAY_D6
DISPLAY_D1:
	LDA d_1,x
 	STA ($10),y
 	INX
 	INY
 	CPY #WIDTH
 	BNE DISPLAY_D1
   
 	INC $12		; increment row counter
 
 	LDA #HEIGHT	; are we done yet?
 	CMP $12
 	BEQ END	; ...exit if we are
 
 	LDA $10		; load pointer
 	CLC
 	ADC #$20	; add 32 to drop one row
 	STA $10
 	LDA $11         ; carry to high byte if needed
 	ADC #$00
 	STA $11
 
 	LDY #$00
 	BEQ DISPLAY_D1

DISPLAY_D2:
	LDA d_2,x
 	STA ($10),y
 	INX
 	INY
 	CPY #WIDTH
 	BNE DISPLAY_D2   
 	INC $12		; increment row counter 
 	LDA #HEIGHT	; are we done yet?
 	CMP $12
 	BEQ END	; ...exit if we are 
 	LDA $10		; load pointer
 	CLC
 	ADC #$20	; add 32 to drop one row
 	STA $10
 	LDA $11         ; carry to high byte if needed
 	ADC #$00
 	STA $11 
 	LDY #$00
 	BEQ DISPLAY_D2

DISPLAY_D3:
	LDA d_3,x
 	STA ($10),y
 	INX
 	INY
 	CPY #WIDTH
 	BNE DISPLAY_D3   
 	INC $12		; increment row counter 
 	LDA #HEIGHT	; are we done yet?
 	CMP $12
 	BEQ END	; ...exit if we are 
 	LDA $10		; load pointer
 	CLC
 	ADC #$20	; add 32 to drop one row
 	STA $10
 	LDA $11         ; carry to high byte if needed
 	ADC #$00
 	STA $11 
 	LDY #$00
 	BEQ DISPLAY_D3

DISPLAY_D4:
	LDA d_4,x
 	STA ($10),y
 	INX
 	INY
 	CPY #WIDTH
 	BNE DISPLAY_D4   
 	INC $12		; increment row counter 
 	LDA #HEIGHT	; are we done yet?
 	CMP $12
 	BEQ END	; ...exit if we are 
 	LDA $10		; load pointer
 	CLC
 	ADC #$20	; add 32 to drop one row
 	STA $10
 	LDA $11         ; carry to high byte if needed
 	ADC #$00
 	STA $11 
 	LDY #$00
 	BEQ DISPLAY_D4

DISPLAY_D5:
	LDA d_5,x
 	STA ($10),y
 	INX
 	INY
 	CPY #WIDTH
 	BNE DISPLAY_D5   
 	INC $12		; increment row counter 
 	LDA #HEIGHT	; are we done yet?
 	CMP $12
 	BEQ END	; ...exit if we are 
 	LDA $10		; load pointer
 	CLC
 	ADC #$20	; add 32 to drop one row
 	STA $10
 	LDA $11         ; carry to high byte if needed
 	ADC #$00
 	STA $11 
 	LDY #$00
 	BEQ DISPLAY_D5

DISPLAY_D6:
	LDA d_6,x
 	STA ($10),y
 	INX
 	INY
 	CPY #WIDTH
 	BNE DISPLAY_D6   
 	INC $12		; increment row counter 
 	LDA #HEIGHT	; are we done yet?
 	CMP $12
 	BEQ END	; ...exit if we are 
 	LDA $10		; load pointer
 	CLC
 	ADC #$20	; add 32 to drop one row
 	STA $10
 	LDA $11         ; carry to high byte if needed
 	ADC #$00
 	STA $11 
 	LDY #$00
 	BEQ DISPLAY_D6
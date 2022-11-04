define WIDTH 	8 ; width of graphic
define HEIGHT 	8 ; height of graphic
 
define SCREEN_POINTER_LO $10
define SCREEN_POINTER_HI $11
 
define DATA_POINTER_LO $40
define DATA_POINTER_HI $41
 
define TEMP_X	$900
define TEMP_Y	$901
define TEMP_A	$902
 
; starting conditions
; X = x position on the screen
; Y = y position on the screen
; A = graphic (can access 0, 1, 2, 3)
 
	LDA #$01
	LDX #$C
	LDY #$B
 
; convert A into a pointer to the graphics data
 
	; save the values in the registers
	STA TEMP_A
	STY TEMP_Y
	STX TEMP_X
	; start with 0 in the hi byte of the pointer
	LDA #$00
	STA SCREEN_POINTER_HI
 
	; multiply the Y value by 32 
	; ... low byte is in A	
	; ... high byte is in SCREEN_POINTER_HI
	TYA
	ASL						
	ROL SCREEN_POINTER_HI
	ASL						
	ROL SCREEN_POINTER_HI
	ASL						
	ROL SCREEN_POINTER_HI
	ASL						
	ROL SCREEN_POINTER_HI
	ASL						
	ROL SCREEN_POINTER_HI
	
 
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
 
; now we can begin! ...
 
 	lda #$00	; number of rows we've drawn
 	sta $12		;   is stored in $12
 
 	ldx #$00	; index for data
 	ldy #$00	; index for screen column
 
	lda TEMP_A
 
	asl 
	asl 
	asl 
	asl 
	ASL
	ASL
	sta DATA_POINTER_LO
	lda #>data
	sta DATA_POINTER_HI
 
 draw:	
	sty TEMP_Y	; save Y then move X to Y
	txa
	tay
	lda (DATA_POINTER_LO),y	; get graphic byte
 
	ldy TEMP_Y	; restore Y register
 	sta (SCREEN_POINTER_LO),y	; put byte on screen	
	lda #<data
 
 	inx
 	iny
 	cpy #WIDTH
 	bne draw
 
 	inc $12		; increment row counter
 
 	lda #HEIGHT	; are we done yet?
 	cmp $12
 	beq done	; ...exit if we are
 
 	lda $10		; load pointer
 	clc
 	adc #$20	; add 32 to drop one row
 	sta $10
 	lda $11         ; carry to high byte if needed
 	adc #$00
 	sta $11
 
 	ldy #$00
 	beq draw
 
 done:	brk		; stop when finished
 
 
*=$4000
 
 data:                 ; graphics to be displayed
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
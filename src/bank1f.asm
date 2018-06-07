bank $1F

// forces game over when hitting a button in weapon menu
org $F806
	PLA
	PLA
	JSR $FF43 // change banks
	JMP $859C // load game over
	
// goes to stage select	
org $F80E
	PLA
	PLA
	PLA
	PLA
	LDA #$DE
	PHA
	LDA #$22
	PHA
	LDA #$10
	LDX #$FF
	LDY #$10
	JSR $FF43 // change banks
	JMP $8583 // load stage select

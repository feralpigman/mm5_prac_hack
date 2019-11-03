bank $01

org $80A5
	// change to accept A, start, and SELECT
	AND #$B0
	
org $80A9
	JMP $BF40 // bank08
	
org $8164
	LDA #$81
	STA $BE
	NOP
	NOP
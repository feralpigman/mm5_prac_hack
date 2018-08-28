bank $01

org $80A5
    // change to accept A, start, and SELECT
    AND #$B0
	
org $80A9
    JMP $BF40 // bank08
bank $17

// controls stage select, setting the correct weapons and
// sending to castles when hitting start
org $81F0
	JSR $9D02
	NOP
	NOP
	
org $8260
	JSR $9E68
	NOP
	
org $9D02
	// figure which castle stage to set it to
	PHA
	// set levelsBeaten to #$FF to skip opening cutscenes
	LDA #$FF
	STA $6E
	// grab the controller input	
	LDA $14
	CMP #$10
	BEQ .sendToCastles
	JSR .loadWeapons
	PLA
    STA $26
    STA $6C
  .loadStage:
    LDA #$28
	JSR $EC5D
    RTS
  .sendToCastles:
	TXA
	PHA
	TYA
	PHA
	LDY #$07
	LDX $10  
  .loopx:
	CPX #$00
	BNE .decx
	LDX $11
  .loopy:
	INY
	CPX #$00
	BNE .decy
	CPY #$0D
	BMI .setStages
	DEY
  .setStages:
	STY $26
	STY $6C
	PLA
	TAY
	PLA
	TAX
    PLA
	JSR .loadWeapons
	JMP .loadStage
  .decx:
	DEX
	INY
	INY
	INY
	JMP .loopx
  .decy:
	DEX
	JMP .loopy
  .loadWeapons:
	LDA #$00
	LDX #$0B
  .resetLoop:
	STA $B1, x
	DEX
	BPL .resetLoop
	// insert code to reset bosses defeated
	STA $6B
	//STA $6E
	// add rush coil
	LDA #$9C
	STA $BA
	LDY #$00
  .setLoop:
	LDA .orderWeapons, y
	// quit if current stage
	CMP $26
	BEQ .done
	// set castle stage weapon energy if done with robot masters
	CMP #$FF
	BEQ .setCastleEnergy
	// load first weapon
	INY
	LDA .orderWeapons, y
	TAX
	LDA #$9C
	STA $00, x
	// load second weapon
	INY
	LDA .orderWeapons, y
	TAX
	LDA #$9C
	STA $00, x
	// load beat letters
	INY
	LDA .orderWeapons, y
	STA $6D
	// set m tank value
	INY
	LDA .orderWeapons, y
	STA $BE
	STA $5D
	INY
	JMP .setLoop
  .setCastleEnergy:
	LDY #$00
  .loopCastleEnergy:
	LDA .castleEnergy, y
	// advance to next stage if not correct stage
	CMP $26
	BNE .advanceCastleEnergy
	// set weapon energy
	JSR .setWeaponEnergy
	JSR .setWeaponEnergy
	JSR .setWeaponEnergy
	// set m tank value
	INY
	LDA .castleEnergy, y
	STA $BE
	STA $5D
  .done:
	// call subroutine to actually load stage
	RTS
  .orderWeapons:
	db $04, $B9, $B5, $10, $00 // star
	db $00, $B7, $B5, $11, $00 // gravity
	db $03, $B2, $BB, $19, $00 // gyro
	db $07, $B3, $B5, $99, $01  // crystal
	db $06, $B4, $B5, $D9, $01 // napalm
	db $02, $B6, $B5, $DD, $01 // stone
	db $05, $B8, $B5, $FD, $01 // charge
	db $01, $B1, $BC, $FF, $01 // wave
	db $FF, $FF, $FF, $FF, $FF
  .castleEnergy:
	db $08, $B0, $9C, $B0, $9C, $B0, $9C, $01 // dark1
	db $09, $B1, $8A, $BB, $96, $BB, $96, $01 // dark2
	db $0A, $B1, $8A, $BB, $96, $BC, $8A, $01 // dark3
	db $0B, $B2, $8D, $B5, $80, $B5, $80, $00 // dark4
	db $0C, $B2, $8D, $B5, $80, $BC, $88, $00 // wily1
	db $0D, $B3, $93, $B5, $80, $B5, $80, $00 // wily 2
	db $0E, $B2, $93, $BB, $9A, $BB, $9A, $00 // wily3
	db $0F, $B5, $8D, $B5, $8D, $B5, $8D, $00 // wily4
  .advanceCastleEnergy:
	INY
	INY
	INY
	INY
	INY
	INY
	INY
	INY
	JMP .loopCastleEnergy
  .setWeaponEnergy:
	INY
	LDA .castleEnergy, y
	TAX
	INY
	LDA .castleEnergy, y
	STA $00, x
	RTS

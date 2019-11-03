bank $17

// hijack the game start/password to set beat/beatless
org $80D7
	JSR .hijackPassword
	NOP
	JMP $80E1
	
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
	// set beat letters to nothing
	STA $6D
	// set mtanks to 0
	LDA #$80	
	STA $BE
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
	JSR .setStageEnergy
	JSR .setStageEnergy
	// load beat letters
	INY
	LDA {use_beat}
	CMP #$00
	BEQ .postBeatLetter
	JMP .setBeatLetter
  .postBeatLetter:
	INY
	JMP .setLoop
  .setCastleEnergy:
	LDY #$00
  .loopCastleEnergy:
	LDA .castleEnergy, y
	// advance to next stage if not correct stage
	CMP $26
	BNE .advanceCastleEnergy
	// set castle weapon energy
	JSR .setCastleWeaponEnergy
	JSR .setCastleWeaponEnergy
	JSR .setCastleWeaponEnergy
  .done:
	// call subroutine to actually load stage
	RTS
  .setStageEnergy:
	// increment weapon column
	INY
	// check if weapon location is beat energy
	LDA .orderWeapons, y
	CMP #$BC
	BEQ .verifyBeatForStageEnergy
  .setStageEnergyValue:
	// load current weapon location
	LDA .orderWeapons, y
	TAX
	LDA #$9C
	STA $00, x
  .stageEnergyReturn:
	RTS
  .verifyBeatForStageEnergy:
    LDA {use_beat}
	CMP #$01
	BEQ .setStageEnergyValue
	JMP .stageEnergyReturn
  .advanceCastleEnergy:
	INY
	INY
	INY
	INY
	INY
	INY
	INY
	JMP .loopCastleEnergy
  .setCastleWeaponEnergy:
	INY
	LDA .castleEnergy, y
	CMP #$BC
	BEQ .verifyBeatForCastleEnergy
  .setCastleEnergyValue:
	LDA .castleEnergy, y
	TAX
	INY
	LDA .castleEnergy, y
	STA $00, x
  .castleEnergyReturn:
	RTS
  .verifyBeatForCastleEnergy:
    LDA {use_beat}
	CMP #$01
	BEQ .setCastleEnergyValue
	INY
	JMP .castleEnergyReturn
  .orderWeapons:
	db $04, $B9, $B5, $10 // star	
	db $00, $B7, $B5, $11 // gravity
	db $03, $B2, $BB, $19 // gyro
	db $07, $B3, $B5, $99 // crystal
	db $06, $B4, $B5, $D9 // napalm
	db $02, $B6, $B5, $DD // stone
	db $05, $B8, $B5, $FD // charge
	db $01, $B1, $BC, $FF // wave
	db $FF, $FF, $FF, $FF
  .castleEnergy:
	db $08, $B0, $9C, $B0, $9C, $B0, $9C // dark1
	db $09, $B1, $8A, $BB, $96, $BB, $96 // dark2
	db $0A, $B1, $8A, $BB, $96, $BC, $8A // dark3
	db $0B, $B2, $8D, $B5, $80, $B5, $80 // dark4
	db $0C, $B2, $8D, $B5, $80, $BC, $88 // wily1
	db $0D, $B3, $93, $B5, $80, $B5, $80 // wily2
	db $0E, $B2, $93, $BB, $9A, $BB, $9A // wily3
	db $0F, $B5, $8E, $B5, $8E, $B5, $8E // wily4

org $9F2A
	// change the password select to go to main menu
  .hijackPassword:
    LDA $0200
	CMP #$A7
	BEQ .setBeat
	JSR .setBeatless
  .donePassword:
    RTS
  .setBeat:
    PHA
	LDA #$01
	STA {use_beat}
	PLA
    JMP .donePassword
  .setBeatless:
    PHA
	LDA #$00
	STA {use_beat}
	PLA
    RTS
  .setBeatLetter:
	LDA .orderWeapons, y
	STA $6D
    JMP .postBeatLetter

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

// util
hex_to_dec:
    // Maps e.g. #69 to $69.
    STA {tmp1}
    LSR
    ADC {tmp1}
    ROR
    LSR
    LSR
    ADC {tmp1}
    ROR
    ADC {tmp1}
    ROR
    LSR
    AND #$3C
    STA {tmp2}
    LSR
    ADC {tmp2}
    ADC {tmp1}
    RTS

org $F860
store_frame_counter:
    // call original line
    JSR $C3B8
    PHA
    LDA {timer_frames}
    STA {last_frames}
    LDA {timer_seconds}
    STA {last_seconds}
    PLA
    RTS	
reset_frame_counter:
// reset frame counter if READY is flashing
  .stage_start:
// this triggers for the small bubbles in wave man
// #$08 in $EE is the part that is the letters
    // check to see if we're in the bank that contains READY
    LDA #$08
    CMP $EE
    BNE .done
    // check to see if the R is showing
    LDA #$81
    CMP $0205
    BEQ .main
    CMP $0221
    BEQ .main
    RTS
  .right:
    LDA #$00
    STA $35
    JMP .main
  .vert:
    LDA $0378
  .main:  
    PHA
    LDA #$FF
    STA {timer_frames}
    LDA #$00
    STA {timer_seconds}
    PLA
  .done:
    RTS	

vertical_transition_spacemaker:
    LDA #$01
    STA $0300
    LDA #$00
    STA $95
    RTS

// show frame counter
org $F906
  show_frame_counter:
    // original line
    JSR $DF5E
    PHA

// Swaps in the CHR ROM with our counter digits in.
// Luckily, the game switches to the appropriate one after the transition by itself.
    LDA #$05 ; STA $EE ; LDA #$66 ; STA $EF
    LDA #$05 ; STA $8000 ; LDA #$66 ; STA $8001

    LDX {last_seconds} ; TXA ; JSR hex_to_dec ; TAX
    LDY {last_frames} ; TYA ; JSR hex_to_dec ; TAY

    // Y
    LDA #$10
    STA $0250 ; STA $0254 ; STA $0258 ; STA $025C ; STA $0260

    // Palette
    LDA #$01
    STA $0252 ; STA $0256 ; STA $025A ; STA $025E ; STA $0262

    // X
    LDA #$D0 ; STA $0253
    LDA #$D8 ; STA $0257
    LDA #$E0 ; STA $025B
    LDA #$E8 ; STA $025F
    LDA #$F0 ; STA $0263

    // timer sprites
    LDA #$CC ; STA $0259
    TXA ; LSR ; LSR ; LSR ; LSR ; ORA #$C0 ; STA $0251
    TXA ; AND #$0F ; ORA #$C0 ; STA $0255
    TYA ; LSR ; LSR ; LSR ; LSR ; ORA #$C0 ; STA $025D
    TYA ; AND #$0F ; ORA #$C0 ; STA $0261

    PLA

    RTS

org $F9A0
  nmi_hook:
    INC $92

    INC {timer_frames} ; LDA {timer_frames} ; CMP #60 ; BNE .done
    INC {timer_seconds} ; LDA #0 ; STA {timer_frames}

  .done:
    JSR reset_frame_counter.stage_start
    LDX #$FF
    RTS		
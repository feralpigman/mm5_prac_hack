bank $0A

org $A2DD
    JSR $A6D2
    NOP
    NOP

org $A6D2
    // set completed stages to 00 so the boss fight loads
    LDA $F2B2,y
    PHA
    LDA #$00
    STA $6E
    PLA
    AND $6E
    RTS
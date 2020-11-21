bank $1E

org $C107
    JSR nmi_hook
    NOP

// save current frame counter for right transition
org $CB96
    JSR store_frame_counter // bank1f

// hook into right transition
org $CC11
    JSR show_frame_counter // bank1f

// reset frame counter after right transition	
org $CC41	
    JSR reset_frame_counter.right
    NOP

// save current frame counter for left transition
org $CC73
    JSR store_frame_counter // bank1f

// hook into left transition
org $CCF2
    JSR show_frame_counter // bank1f

// reset frame counter after left transition
org $CCFB
    // make space for our extra JSR call
    JSR vertical_transition_spacemaker
    JSR $FF22
    INC $95
    LDA $FC
    BNE $CC8E
    STA $35	
    JSR reset_frame_counter.main
    NOP
    NOP
    NOP

// save current frame counter for vertical transition
org $CE90
    JSR store_frame_counter // bank1f

// hook into vertical transition
org $CF16
    JSR show_frame_counter // bank1f

// reset frame counter after vertical transition	
org $CF39
    JSR reset_frame_counter.vert



arch nes.cpu
header

banksize $2000

incsrc "defines.asm"
incsrc "bank17.asm" // stage select, password hijack
incsrc "bank0a.asm" // set completed stages to 00 so the boss fight loads
incsrc "bank01.asm" // hijacks menu to warp to stage select
incsrc "bank08.asm" // sets ram so that menu warp works, this simulates a game over
incsrc "bank1f.asm" // post bank change stuff
incsrc "bank1e.asm" // frame counter
//incsrc "bank1b.asm" // show frame counter after boss kill
incsrc "gfx.asm"
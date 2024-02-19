FastPauseZ80: macro
    move.w  #$100, (Z80BusReq)
    endm

ResumeZ80: macro
    move.w  #$000, (Z80BusReq)
    endm




Z80Ram:     equ $A00000  ; Where Z80 RAM starts
Z80BusReq:  equ $A11100  ; Z80 bus request line
Z80Reset:   equ $A11200  ; Z80 reset line
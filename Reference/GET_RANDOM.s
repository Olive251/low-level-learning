define      ROLL        $100
define      ROLL_BUFFER $105
define      ROLL_MAX    07      ; have tried implementing the min/max in various formats
define      ROLL_MIN    01      ; ...and increasing the range to 0-600, but still does not catch

ROLLER:
    LDA $FE
    AND #7

    CMP #ROLL_MAX
    BCS ROLLER

    CMP #ROLL_MIN
    BCC ROLLER

    STA ROLL

    JMP DONE

DONE:
    brk
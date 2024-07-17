; An empty ASM program ...

ORG 0

    ; --------------------
    ; Count from 0.0 to 5.0
    LOAD    ZERO
    IN      Timer2
LOOP1:
    OUT     Timer2
    OUT     Hex0
    SUB     FIVE
    JNEG    LOOP1
    ; --------------------
    ; Count to 16.0 from 21.0
    LOAD    SIXTEEN
    IN      Timer2
LOOP2:
    OUT     Timer2
    OUT     Hex0
    SUB     TWENTY_ONE
    JNEG    LOOP2
    ; --------------------

	JUMP    0

; IO address constants
ZERO:       DW  0
FIVE:       DW  50
SIXTEEN:    DW  160
TWENTY_ONE: DW  210

Switches:   EQU 000
LEDs:       EQU 001
Timer:      EQU 002
Hex0:       EQU 004
Hex1:       EQU 005
Timer2:     EQU 006

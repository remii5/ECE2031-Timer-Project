; An empty ASM program ...

ORG 0

    ; --------------------
    ; Count from 0.0 to 5.0
    LOAD    ZERO
    OUT     Timer2
LOOP1:
    IN      Timer2
    OUT     Hex1
    SUB     FIVE
    JNEG    LOOP1
    ; --------------------
    ; Count to 2.5 from 7.5
    LOAD    TWO_FIVE
    OUT     Timer2
LOOP2:
    IN      Timer2
    OUT     Hex0
    SUB     SEVEN_FIVE
    JNEG    LOOP2
    ; --------------------

	JUMP    0

; IO address constants
ZERO:       DW  0
TWO_FIVE:   DW  25
FIVE:       DW  50
SEVEN_FIVE: DW  75

; Variables
TEMP:       DW  0

Switches:   EQU 000
LEDs:       EQU 001
Timer:      EQU 002
Hex0:       EQU 004
Hex1:       EQU 005
Timer2:     EQU 006

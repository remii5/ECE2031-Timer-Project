; TIMER_FREQ_TEST.asm
; Timer recieves frequency from ACC during OUT instruction
; Tests each clock frequencies and outputs to Hex Display
; Last updated on 7/17/2024

ORG 0

    ; --------------------
    ; Count to 100, Clock = 4Hz
    LOAD    4Hz
    OUT     Timer2
    CALL    COUNT
    ; --------------------
    ; Count to 100, Clock = 10Hz
    LOAD    10Hz
    OUT     Timer2
    CALL    COUNT
    ; --------------------
    ; Count to 100, Clock = 32Hz
    LOAD    32Hz
    OUT     Timer2
    CALL    COUNT
    ; --------------------
    ; Count to 100, Clock = 100Hz
    LOAD    100Hz
    OUT     Timer2
    CALL    COUNT
    ; --------------------
    ; Count to 100, Clock = 10kHz
    LOAD    10kHz
    OUT     Timer2
    CALL    COUNT
    ; --------------------
    ; Count to 100, Clock = 100kHz
    LOAD    100kHz
    OUT     Timer2
    CALL    COUNT
    ; --------------------
    ; Restart
	JUMP    0

COUNT:
    IN      Timer2
    OUT     Hex1
    SUB     HUNDRED
    JNEG    COUNT
    RETURN

; CLOCK Frequencies
; OTHER = 10Hz
4Hz:        DW  0
10Hz:       DW  1
32Hz:       DW  2
100Hz:      DW  3
10kHz:      DW  4
100kHz:     DW  5

; Values
HUNDRED     DW  100

; IO address constants
Switches:   EQU 000
LEDs:       EQU 001
Timer:      EQU 002
Hex0:       EQU 004
Hex1:       EQU 005
Timer2:     EQU 006

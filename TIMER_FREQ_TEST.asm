; TIMER_FREQ_TEST.asm
; Timer recieves frequency from ACC during OUT instruction
; Tests each clock frequencies and outputs to Hex Display
; Last updated on 7/17/2024

ORG 0

    ; --------------------
    ; Count to 20, Clock = 1 Hz
    LOADI   1
    OUT     TIMER_FREQ
    CALL    COUNT
    ; --------------------
    ; Count to 20, Clock = 2 Hz
    LOADI   2
    OUT     TIMER_FREQ
    CALL    COUNT
    ; --------------------
    ; Count to 20, Clock = 4 Hz
    LOADI   4
    OUT     TIMER_FREQ
    CALL    COUNT
    ; --------------------
    ; Count to 20, Clock = 8 Hz
    LOADI   8
    OUT     TIMER_FREQ
    CALL    COUNT
    ; --------------------
    ; Count to 20, Clock = 20 Hz
    LOADI   20
    OUT     TIMER_FREQ
    CALL    COUNT
    ; --------------------
    ; Restart
	JUMP    0

COUNT:
    IN      TIMER_FREQ
    OUT     Hex1
    SUB     LIMIT
    JNEG    COUNT
    RETURN

; Values
LIMIT:    DW  20

; IO address constants
Switches:   EQU 000
LEDs:       EQU 001
TIMER_ACC:  EQU 002
TIMER_FREQ: EQU 003
Hex0:       EQU 004
Hex1:       EQU 005

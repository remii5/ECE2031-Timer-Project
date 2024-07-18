; TIMER_TEST.asm
; ----------------------------------------------------------
; TIMER_FREQ controls the timer clock speed
;       ACC = Freq (Neg, Zero, Pos)
;           If ACC = 0, then stop timer
;           Else if ACC = POS, then count up
;           Else if ACC = NEG, then count down
; TIMER stores the counter and does the counting
;       ACC = Set Counter Value
; ----------------------------------------------------------
; Tests each clock frequencies and outputs to Hex Display
; Last updated on 7/18/2024

ORG 0
    ; Stop timer and set counter = 0
    LOADI   0
    OUT     TIMER_FREQ
    OUT     TIMER

    ; Start timer with 2 Hz and count until 10
    LOADI   2
    OUT     TIMER_FREQ
    CALL    COUNT_UP

    ; Stop timer
    LOADI   0
    OUT     TIMER_FREQ

    ; Set counter = 10 and start timer with -2 Hz
    LOADI   10
    OUT     TIMER
    LOADI   -2
    OUT     TIMER_FREQ
    CALL    COUNT_DOWN

    ; ------------------------------------------

    ; Stop timer and set counter = 0
    LOADI   0
    OUT     TIMER_FREQ
    OUT     TIMER

    ; Start timer with 2 Hz and count until 10
    LOADI   10
    OUT     TIMER_FREQ
    CALL    COUNT_UP

    ; Stop timer
    LOADI   0
    OUT     TIMER_FREQ

    ; Set counter = 10 and start timer with -2 Hz
    LOADI   10
    OUT     TIMER
    LOADI   -10
    OUT     TIMER_FREQ
    CALL    COUNT_DOWN

	JUMP    0

COUNT_UP:
    IN      TIMER
    OUT     Hex1
    SUB     LIMIT
    JNEG    COUNT_UP
    RETURN

COUNT_DOWN:
    IN      TIMER_FREQ
    OUT     Hex1
    JPOS    COUNT_DOWN
    RETURN

; Values
LIMIT:      DW  10

; IO address constants
Switches:   EQU 000
LEDs:       EQU 001
TIMER:      EQU 002
TIMER_FREQ: EQU 003
Hex0:       EQU 004
Hex1:       EQU 005

; TIMER_TEST.asm
; ----------------------------------------------------------
; TIMER_FREQ control the clock speed going to the clock
;       ACC = Freq (Neg, Zero, Pos)
;       If ACC = 0, then stop timer
;       Else if ACC = POS, then count up
;       Else if ACC = NEG, then count down
; TIMER stores the counter and does the counting
;       ACC = Starting Value
; ----------------------------------------------------------
; Tests each clock frequencies and outputs to Hex Display
; Last updated on 7/18/2024

ORG 0
    LOADI   0
    OUT     TIMER_FREQ
    OUT     TIMER

    LOADI   1
    CALL    SET_FREQ_AND_COUNT_UP_BY_4

    LOADI   2
    CALL    SET_FREQ_AND_COUNT_UP_BY_4

    LOADI   4
    CALL    SET_FREQ_AND_COUNT_UP_BY_4

    ; -------------------------

    LOADI   -1
    CALL    SET_FREQ_AND_COUNT_DOWN_BY_4

    LOADI   -2
    CALL    SET_FREQ_AND_COUNT_DOWN_BY_4

    LOADI   -4
    CALL    SET_FREQ_AND_COUNT_DOWN_BY_4

    ; --------------------------

    CALL    STOP_TIMER_AND_CHECK

    LOADI   40
    OUT     TIMER_FREQ
    LOADI   100
    STORE   COUNT
    CALL    COUNT_FUNC_UP

    LOADI   1
    CALL    SET_FREQ_AND_COUNT_UP_BY_4

    ; -------------------------

    CALL    STOP_TIMER_AND_CHECK

    ; -------------------------

    LOADI   1
    CALL    SET_FREQ_AND_COUNT_UP_BY_4

    ; -------------------------

    LOADI   -40
    OUT     TIMER_FREQ
    LOADI   200
    STORE   COUNT
    CALL    COUNT_FUNC_DOWN

    ; -------------------------

    LOADI   1
    CALL    SET_FREQ_AND_COUNT_UP_BY_4

    ; -------------------------

    LOADI   0
    OUT     TIMER
    CALL    STOP_TIMER_AND_CHECK
	JUMP    0

    ; -------------------------

COUNT_FUNC_UP:
    IN      TIMER
    STORE   INIT
LOOP1:
    IN      TIMER
    OUT     Hex1
    SUB     COUNT
    SUB     INIT
    JNEG    LOOP1
    RETURN

COUNT_FUNC_DOWN:
    IN      TIMER
    STORE   INIT
LOOP2:
    IN      TIMER
    OUT     Hex1
    JZERO   END
    SUB     INIT
    ADD     COUNT
    JPOS    LOOP2
END:
    RETURN

STOP_TIMER_AND_CHECK:
    LOADI   0
    OUT     TIMER_FREQ
WHILE1:
    IN      TIMER
    OUT     HEX1
    IN      Switches
    JZERO   WHILE1
    RETURN

SET_FREQ_AND_COUNT_UP_BY_4:
    OUT     TIMER_FREQ
    LOADI   4
    STORE   COUNT
    CALL    COUNT_FUNC_UP
    RETURN

SET_FREQ_AND_COUNT_DOWN_BY_4:
    OUT     TIMER_FREQ
    LOADI   4
    STORE   COUNT
    CALL    COUNT_FUNC_DOWN
    RETURN

; Values
LIMIT:      DW  10
COUNT:      DW  0
INIT:       DW  0

SEVEN:       DW  7
HUNDRED:    DW  100

; IO address constants
Switches:   EQU 000
LEDs:       EQU 001
TIMER:      EQU 002
TIMER_FREQ: EQU 003
Hex0:       EQU 004
Hex1:       EQU 005

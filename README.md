# ECE 2031 Final Project

### Functionality added so far:

1. TIMER peripheral
    - Stores current counter value
    - Does the counting
2. TIMER_FREQ peripheral
    - Provides user-specified timer speed in Hz

### TIMER BDF Structure:

![TIMER.png](https://github.com/ecuasonic/ECE2031-Timer-Project/blob/main/TIMER.png)

### VHDL Organization:

The TIMER and TIMER_FREQ are currently in separate vhdl files, but it is possible to merge them together into a single vhdl file, and have two Chip Select inputs to differ between the two.
The peripherals are separated for now for debugging simplicity.

### Assembly Code Example:
```asm
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
```

### Overall SCOMP_System BDF structure:

![SCOMP_SystemBDF.png](https://github.com/ecuasonic/ECE2031-Timer-Project/blob/main/SCOMP_SystemBDF.png)

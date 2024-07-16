Slow Down/ Speed Up Timer
Reverse Timer
When `OUT Timer`, then `Timer_time = ACC`, instead of `Timer_time = 0`.

1. Configurable Frequency for the timer
- **Problem**: Currently the timer count is fixed at 10 hz so we could improve upon this by allowing it to be configurable
- **Possible implementation**: new I/O address to set frequency
```asm
TimerFreq: EQU 033 ; I/O address for setting the frequency
  LOADI 15 
  OUT TimerFreq	; sets to 15 hz
```

2. Enabling / Disabling the timer
- **Problem**: There is no way to stop the timer with the only user control being able to reset it. This could be improved to start / stop the timer
- **Possible implementation**:
```asm
TimerCtrl: EQU 034 ; I/O address for enabling/disabling the timer
LOADI 1 
OUT TimerCtrl	; this enables the timer
```

3. Reverse / Countdown timer
Problem: Timer can only count up from 0. This could be improved so that it can count down from a specified value to 0

4. Timer takes in value of AC instead of resetting when OUT
**Problem**: Current timer is limited in that the user can only reset it with an OUT. Sometimes newer users to SCOMP may tend to do a LOADI 0 then TIMER OUT which creates confusion. This can be improved by just taking in the number in the AC and setting the timer to that number.
```asm
COUNT <= IO_DATA
```

**Contingency plan if one of these ideas doesn’t work**:
5. Timer value in different formats
- **Problem**: Currently, the timer only displays on hex1 in hexadecimal. We can take advantage of the full 7-segment display in order to have binary and decimal that the user can switch between

-- TIMER2.VHD (a peripheral for SCOMP)
-- 2024.07.08
--
-- This timer provides a 16 bit counter value with a resolution of the CLOCK period.
-- Writing any value to timer resets to 0x0000, but the timer continues to run.
-- The counter value rolls over to 0x0000 after a clock tick at 0xFFFF.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;  -- unsigned and to_integer
USE LPM.LPM_COMPONENTS.ALL;

ENTITY TIMER2 IS
    PORT(CLOCK,
        RESETN,
        CS,
        IO_WRITE : IN    STD_LOGIC;
        IO_DATA  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  TIMER2_CTRL_EN : IN  STD_LOGIC  -- New input for direction control
    );
END TIMER2;

ARCHITECTURE a OF TIMER2 IS
    SIGNAL COUNT     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IO_COUNT  : STD_LOGIC_VECTOR(15 DOWNTO 0); -- a stable copy of the count for the IO
    SIGNAL OUT_EN    : STD_LOGIC;
	 SIGNAL COUNT_UP  : STD_LOGIC := '1';  -- Default to counting up (so 1 is up and anything else is down)

    BEGIN

    -- Use Intel LPM IP to create tristate drivers
    IO_BUS: lpm_bustri
    GENERIC MAP (
        lpm_width => 16
    )
    PORT MAP (
        data     => IO_COUNT,
        enabledt => OUT_EN,
        tridata  => IO_DATA
    );

    -- IO data should be driven when SCOMP is requesting data
    OUT_EN <= (CS AND NOT(IO_WRITE));

    PROCESS (CLOCK, RESETN, CS, IO_WRITE)
    BEGIN
        IF (RESETN = '0') THEN
            COUNT <= x"0000";
        ELSIF (CS = '1' AND IO_WRITE = '1' AND TIMER2_CTRL_EN = '1') THEN
            COUNT_UP <= IO_DATA(0);  -- this should get the first bit of IO_DATA
        ELSIF (rising_edge(CLOCK)) THEN
            IF COUNT_UP = '1' THEN
                COUNT <= std_logic_vector(unsigned(COUNT) + 1); -- had to convert it from an integer then back to a vector
            ELSE
                COUNT <= std_logic_vector(unsigned(COUNT) - 1);
            END IF;
        END IF;
    END PROCESS;

    -- Use a latch to prevent IO_COUNT from changing while an IO operation is occuring.
    -- Note that this is only safe because the clock used for this peripheral
    -- is derived from the same clock used for SCOMP; they're not separate
    -- clock domains.
    PROCESS (CS, COUNT, IO_COUNT)
    BEGIN
        IF CS = '1' THEN
            IO_COUNT <= IO_COUNT;
        ELSE
            IO_COUNT <= COUNT;
        END IF;
    END PROCESS;

END a;
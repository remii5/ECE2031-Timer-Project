-- TIMER2.VHD (a peripheral for SCOMP)
-- 2024.07.08
--
-- This timer provides a 16 bit counter value with a resolution of the CLOCK period.
-- Writing any value to timer resets to 0x0000, but the timer continues to run.
-- The counter value rolls over to 0x0000 after a clock tick at 0xFFFF.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY TIMER IS
    PORT (
    CLOCK,
    RESETN,
    CS,
    NEG_FREQ,
    IO_WRITE : IN    STD_LOGIC;
    IO_DATA  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END TIMER;

ARCHITECTURE a OF TIMER IS
    SIGNAL COUNT     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IO_COUNT  : STD_LOGIC_VECTOR(15 DOWNTO 0); -- a stable copy of the count for the IO
    SIGNAL OUT_EN    : STD_LOGIC;

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

    OUT_EN <= (CS AND NOT(IO_WRITE));

    PROCESS (CLOCK, RESETN, CS, IO_WRITE)
    BEGIN
        IF (RESETN = '0') THEN
            COUNT <= x"0000";
        ELSIF ((CS AND IO_WRITE) = '1') THEN
            COUNT <= IO_DATA;
        ELSIF (rising_edge(CLOCK)) THEN
            IF (NEG_FREQ = '0') THEN
                COUNT <= COUNT + 1;
            ELSIF (COUNT = x"0000") THEN
                COUNT <= COUNT;
            ELSE
                COUNT <= COUNT - 1;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (CS, COUNT, IO_COUNT)
    BEGIN
        IF CS = '1' THEN
            IO_COUNT <= IO_COUNT;
        ELSE
            IO_COUNT <= COUNT;
        END IF;
    END PROCESS;

END a;

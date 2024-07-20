-- TIMER.vhd (Second part of two-part peripheral)
-- Last updated on 7/20/2024
--
-- Behavior:
--      TIMER stores the counter and does the counting
--          On OUT instruction, counter = ACC
--      If NEG_FREQ = 0, then count++
--          counter is always non-negative and ranges from x0000 to x7FFF
--          if counter = x7FFF, then counter = x0000
--      Else if count = 0 or count < 0, then count = 0
--      Else, then count--

-- OUT TIMER : Sets Timer counter
-- IN TIMER : Gets Timer counter

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
            ELSIF (COUNT = x"0000" OR COUNT(15) = '1') THEN
                COUNT <= x"0000";
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

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

ENTITY TIMER_FREQ IS
    PORT (
    CLOCK_12MHz     : IN STD_LOGIC;
    RESETN          : IN STD_LOGIC;
    CS              : IN STD_LOGIC;
    IO_WRITE        : IN STD_LOGIC;
    IO_DATA         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    NEG_FREQ        : OUT STD_LOGIC;
    TIMER_CLOCK     : OUT STD_LOGIC
);
END TIMER_FREQ;

ARCHITECTURE a OF TIMER_FREQ IS
    CONSTANT clk_freq    : INTEGER := 12000000;
    CONSTANT half_freq   : INTEGER := clk_freq/2;

    SIGNAL clock_int    : STD_LOGIC;
    SIGNAL clock_count  : STD_LOGIC_VECTOR(23 DOWNTO 0);
    SIGNAL input_freq   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL neg          : STD_LOGIC;

    SIGNAL divisor      : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL quotient     : STD_LOGIC_VECTOR(23 DOWNTO 0);
    SIGNAL remain       : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL div_ready    : STD_LOGIC;

    COMPONENT lpm_divide
        GENERIC (
            lpm_widthd  : INTEGER := 24;
            lpm_widthn  : INTEGER := 24
        );
        PORT (
            denom       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            numer       : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
            quotient    : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
            remain      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    PROCESS (CLOCK_12MHz, RESETN)
    BEGIN
        IF (RESETN = '0') THEN
            clock_count <= (OTHERS => '0');
            clock_int <= '0';
        ELSIF (rising_edge(CLOCK_12MHz)) THEN
            IF (input_freq = x"0000") THEN
                clock_count <= clock_count;
            ELSIF clock_count < (quotient - 1) THEN
                clock_count <= clock_count + 1;
            ELSE
                clock_count <= (OTHERS => '0');
                clock_int <= NOT clock_int;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (clock_int, RESETN, CS, IO_WRITE)
    BEGIN
        IF (RESETN = '0') THEN
            -- default clock freq = 10Hz
            input_freq <= x"000A";
            neg <= '0';
        ELSIF ((CS AND IO_WRITE) = '1') THEN
            IF (IO_DATA(15) = '1') THEN
                input_freq <= NOT(IO_DATA) + 1;
                neg <= '1';
            ELSE
                input_freq <= IO_DATA;
                neg <= '0';
            END IF;
        END IF;
    END PROCESS;

    TIMER_CLOCK <= clock_int;
    NEG_FREQ <= neg;

END a;

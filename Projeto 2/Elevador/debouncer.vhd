-- =============================================================
-- Debounce module
-- Author: Chipmunk Logic 
-- Used for: Verilog projects, VHDL projects, FPGA projects
-- Description:
--   This VHDL module filters mechanical switch or button inputs 
--   to remove contact bounce. It ensures that only one clean,
--   single-cycle pulse is generated for each valid button press.
--
--   The circuit uses a 2-stage synchronizer to avoid metastability,
--   a counter to verify signal stability, and an edge detector
--   to produce a one-clock-cycle output pulse.
--
-- =============================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    port (
        clk     : in  std_logic;   -- System clock (e.g. 50 MHz)
        btn_in  : in  std_logic;   -- Raw mechanical button input (noisy)
        pulse   : out std_logic    -- Clean single-clock pulse output
    );
end entity;

architecture rtl of debounce is
    ----------------------------------------------------------------
    -- Internal signal declarations
    ----------------------------------------------------------------
    signal sync_0, sync_1 : std_logic := '0';  -- Two-stage input synchronizer
    signal counter : unsigned(19 downto 0) := (others => '0'); -- ~10ms debounce counter @50MHz
    signal debounced, debounced_prev : std_logic := '0';       -- Stable and previous states
begin
    ----------------------------------------------------------------
    -- Input Synchronizer
    -- Two flip-flop stages are used to bring the asynchronous
    -- button signal into the system clock domain, preventing
    -- metastability issues.
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            sync_0 <= btn_in;  -- Capture button input
            sync_1 <= sync_0;  -- Second synchronization stage
        end if;
    end process;

    ----------------------------------------------------------------
    -- Debounce Logic
    -- The signal must remain stable for a fixed duration (10 ms)
    -- before updating the debounced output. If the signal toggles
    -- prematurely, the counter is reset and the process restarts.
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if sync_1 = debounced then
                -- Input is stable; reset counter
                counter <= (others => '0');
            else
                -- Input changed; increment counter to confirm stability
                counter <= counter + 1;

                -- If stable long enough, update debounced state
                if counter = to_unsigned(500000, counter'length) then -- 10 ms @50MHz
                    debounced <= sync_1;
                    counter <= (others => '0');
                end if;
            end if;

            -- Store previous debounced state for edge detection
            debounced_prev <= debounced;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Pulse Generation
    -- Generates a clean single-clock pulse whenever the debounced
    -- signal transitions from LOW to HIGH (button press event).
    ----------------------------------------------------------------
    pulse <= '1' when (debounced = '1' and debounced_prev = '0') else '0';

end architecture;

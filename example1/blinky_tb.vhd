--------------------------------------------------------------------------------
-- blink_tb.v
--------------------------------------------------------------------------------

-- library std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.env.all;
library work;

entity tb is
end entity tb;

architecture sim of tb is
  signal system_reset_n      : std_logic := '1';
  signal gpio_led            : std_logic;
  signal gpio_led2           : std_logic;
  signal system_clock_100mhz : std_logic := '0';
  signal ii_prev             : integer   := 0;
  signal ii_delta            : integer   := 0;
  signal fail_cnt            : integer   := 0;
  signal first_time          : boolean   := True;
begin

  -- ==========================================================================
  -- Generate a clock that toggles every 5nsec, resulting in a 100MHz pulsing
  -- clock with a 50% duty cycle
  process
  begin
   wait for 5 ns;
   system_clock_100mhz <=  not system_clock_100mhz; -- toggle the clock
  end process;
--
-- 
 
  u_blinky: entity work.blinky
  generic map (
    CNT_WIDTH => 9
  )
  port map (
    clk   => system_clock_100mhz, -- in
    rst_n => system_reset_n,      -- in
    led   => gpio_led             -- out
  );


  -- ==========================================================================
  -- MAIN TEST INITIAL BLOCK
--
--
--
--
--
--
--
  main_test: process
  begin

    -- SIMULATION STARTUP
    -- VHDL uses 'report' to print text to the screen. It's syntax
    -- is similar to Python's string concatenation.
    report(" info: Start of Simulation integer example = " & to_string(ii_prev));

    -- Wait for the 1st rising clock edge and then drive the reset low to
    -- reset the blinky module.
    wait until rising_edge(system_clock_100mhz);
    system_reset_n <= '0';

    -- Wait for 10 more clocks, with the reset still assserted low.
    for i in 1 to 10 loop
      wait until rising_edge(system_clock_100mhz);
    end loop;

    -- Drive the reset high which enables the blinky to start working. Wait
    -- for 10 more clocks just for good measure.
    system_reset_n <= '1';
    for i in 1 to 10 loop wait until rising_edge(system_clock_100mhz); end loop;


    -- SIMULATION RUNS FOR A LONG TIME. BLINKY SHOULD PULSE MANY TIMES
    -- This waits for 10000 clocks.
    for ii in 0 to 10000-1 loop
      gpio_led2 <= gpio_led;
      wait until rising_edge(system_clock_100mhz);
      if gpio_led /= gpio_led2 then
        ii_delta <= ii - ii_prev;
        wait for 1 ns;
        if ii_delta = 256 then
          report(" nsec : PASS GPIO_LED changing from " & to_string(gpio_led2) &
                 " to " & to_string(gpio_led) & ". blink rate = " &
                 to_string(ii_delta) & " clocks");
        else -- elsif
          if not first_time then
            fail_cnt <= fail_cnt + 1;
            report(" nsec : FAIL GPIO_LED changing from " & to_string(gpio_led2) &
                 " to " & to_string(gpio_led) & ". blink rate = " &
                 to_string(ii_delta) & " clocks");
          end if;
        end if;
        first_time <= False;
        ii_prev <= ii;
      end if;
    end loop;

    -- MOP-UP SIMULULATION
    for i in 1 to 20 loop
      wait until rising_edge(system_clock_100mhz);
    end loop;

    report(lf & "=====================================================================" & lf);
    if fail_cnt = 0 then
      report(": TEST PASSED");
    else
      report(": TEST FAILED. %d tests failed" & to_string(fail_cnt));
    end if;

    report(" info: End of Simulation");

    -- The finish command stops the verilog simulation
    finish;
--  wait;
  end process main_test;

end architecture sim;



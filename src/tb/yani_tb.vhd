library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library yani;
use yani.constants.all;

entity yani_tb is

end yani_tb;

architecture rtl of yani_tb is
    constant CLK_PERIOD         : time := 10 ns;

    signal clk                  : std_ulogic;
    signal rst                  : std_ulogic;
    signal start                : std_ulogic;

    signal done                 : std_ulogic;

    shared variable done_sim    : boolean := false;
begin

    dut: entity yani.top generic map (
        MEMORY_IMAGE_FILE_PATH => "mult_sum.mem"
    )
    port map (
        clk_i   => clk,
        rst_i   => rst,
        start_i => start,

        done_o  => done
    );

    process
    begin
        if done_sim = false then
            clk <= '1';
            wait for CLK_PERIOD / 2;
            clk <= '0';
            wait for CLK_PERIOD / 2;
        else
            wait;
        end if;
    end process;

    process
    begin
        rst <= '1';
        start <= '0';
        wait for CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until done = '1';
        report "Finished executing!";
        done_sim := true;
        wait;
    end process;

end rtl;

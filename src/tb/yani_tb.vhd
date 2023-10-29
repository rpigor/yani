library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library yani;
use yani.constants.all;

entity yani_tb is

end yani_tb;

architecture rtl of yani_tb is
    constant clk_period         : time := 10 ns;

    signal clk                  : std_ulogic;
    signal rst                  : std_ulogic;
    signal start                : std_ulogic;

    signal done                 : std_ulogic;
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
        clk <= '1';
        wait for clk_period / 2;
        clk <= '0';
        wait for clk_period / 2;
    end process;

    process
    begin
        rst <= '1';
        start <= '0';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        start <= '1';
        wait for clk_period;
        start <= '0';
        wait;
    end process;

end rtl;

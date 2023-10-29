library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library yani;
use yani.constants.all;

entity memory_tb is

end memory_tb;

architecture rtl of memory_tb is
    constant clk_period : time := 10 ns;

    signal rst          : std_ulogic;
    signal addr         : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal data         : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal write        : std_ulogic;

    signal mem_output   : std_ulogic_vector(BIT_WIDTH-1 downto 0);
begin

    dut: entity yani.memory generic map (
        MEM_FILE_PATH   => "memory_test.mem",
        MEM_SIZE        => 512
    )
    port map (
        rst_i   => rst,
        addr_i  => addr,
        data_i  => data,
        write_i => write,

        mem_o   => mem_output
    );

    process
    begin
        rst <= '1';
        addr <= (others => '0');
        data <= (others => '0');
        write <= '0';
        wait for clk_period;
        rst <= '0';
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(0, BIT_WIDTH));
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(1, BIT_WIDTH));
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(2, BIT_WIDTH));
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(3, BIT_WIDTH));
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(4, BIT_WIDTH));
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(99, BIT_WIDTH));
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(5, BIT_WIDTH));
        data <= std_ulogic_vector(to_unsigned(42, BIT_WIDTH));
        wait for clk_period;
        write <= '1';
        wait for clk_period;
        write <= '0';
        addr <= std_ulogic_vector(to_unsigned(1, BIT_WIDTH));
        wait for 5*clk_period;
        addr <= std_ulogic_vector(to_unsigned(5, BIT_WIDTH));
        wait;
    end process;

end rtl;

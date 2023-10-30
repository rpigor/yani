library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library yani;
use yani.constants.all;

entity control_tb is

end control_tb;

architecture rtl of control_tb is
    constant CLK_PERIOD         : time := 10 ns;

    signal clk                  : std_ulogic;
    signal rst                  : std_ulogic;
    signal start                : std_ulogic;

    signal instr_reg            : std_ulogic_vector(INSTR_WIDTH-1 downto 0);
    signal neg_zero_reg         : std_ulogic_vector(1 downto 0);

    signal alu_op               : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0);
    signal sel_mem_addr         : std_ulogic;
    signal sel_mem_data         : std_ulogic;
    signal incr_pc              : std_ulogic;
    signal write_mem            : std_ulogic;
    signal load_pc_reg          : std_ulogic;
    signal load_instr_reg       : std_ulogic;
    signal load_mem_addr_reg    : std_ulogic;
    signal load_mem_data_reg    : std_ulogic;
    signal load_acc_reg         : std_ulogic;
    signal load_neg_zero_reg    : std_ulogic;

    signal done                 : std_ulogic;

    shared variable done_sim    : boolean := false;
begin

    dut: entity yani.control port map (
        clk_i               => clk,
        rst_i               => rst,
        start_i             => start,

        instr_reg_i         => instr_reg,
        neg_zero_reg_i      => neg_zero_reg,

        alu_op_o            => alu_op,
        sel_mem_addr_o      => sel_mem_addr,
        sel_mem_data_o      => sel_mem_data,
        incr_pc_o           => incr_pc,
        write_mem_o         => write_mem,
        load_pc_reg_o       => load_pc_reg,
        load_instr_reg_o    => load_instr_reg,
        load_mem_addr_reg_o => load_mem_addr_reg,
        load_mem_data_reg_o => load_mem_data_reg,
        load_acc_reg_o      => load_acc_reg,
        load_neg_zero_reg_o => load_neg_zero_reg,

        done_o              => done
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
        wait for CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;
        instr_reg <= "0100";
        neg_zero_reg <= "00";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait for 8*CLK_PERIOD;
        instr_reg <= "0101";
        wait for 8*CLK_PERIOD;
        instr_reg <= "1111";
        wait until done = '1';
        report "Finished executing!";
        done_sim := true;
        wait;
    end process;

end rtl;

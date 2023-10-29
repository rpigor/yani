library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library yani;
use yani.constants.all;

entity alu is
    port (
        alu_op_i    : in std_ulogic_vector(ALU_OP_WIDTH-1 downto 0);
        acc_i       : in std_ulogic_vector(BIT_WIDTH-1 downto 0);
        mem_i       : in std_ulogic_vector(BIT_WIDTH-1 downto 0);

        alu_res_o   : out std_ulogic_vector(BIT_WIDTH-1 downto 0);
        alu_zero_o  : out std_ulogic;
        alu_neg_o   : out std_ulogic
    );
end alu;

architecture rtl of alu is
    signal alu_res : std_ulogic_vector(BIT_WIDTH-1 downto 0);
begin
    alu_res_o <= alu_res;

    alu_operations: process(alu_op_i, acc_i, mem_i)
    begin
        case alu_op_i is
            when ALU_ADD        => alu_res <= std_ulogic_vector(unsigned(acc_i) + unsigned(mem_i));
            when ALU_SUB        => alu_res <= std_ulogic_vector(unsigned(acc_i) - unsigned(mem_i));
            when ALU_SHIFT_R    => alu_res <= (to_integer(unsigned(mem_i))-1 downto 0 => '0') & acc_i(acc_i'left-to_integer(unsigned(mem_i)) downto 0);
            when ALU_SHIFT_L    => alu_res <= acc_i(acc_i'left downto to_integer(unsigned(mem_i))-1) & (to_integer(unsigned(mem_i))-1 downto 0 => '0');
            when ALU_AND        => alu_res <= acc_i and mem_i;
            when ALU_OR         => alu_res <= acc_i or mem_i;
            when ALU_XOR        => alu_res <= acc_i xor mem_i;
            when ALU_NOT        => alu_res <= not acc_i;
            when ALU_OP_ID      => alu_res <= mem_i;
            when others         => alu_res <= mem_i;
        end case;
    end process alu_operations;

    alu_zero_o <= '1' when (alu_res = (alu_res'range => '0')) else '0';
    alu_neg_o <= '1' when (alu_res(alu_res'left) = '1') else '0';
end rtl;

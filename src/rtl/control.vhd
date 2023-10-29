library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library yani;
use yani.constants.all;

entity control is
    port (
        clk_i               : in std_ulogic;
        rst_i               : in std_ulogic;
        start_i             : in std_ulogic;

        instr_reg_i         : in std_ulogic_vector(INSTR_WIDTH-1 downto 0);
        neg_zero_reg_i      : in std_ulogic_vector(1 downto 0);

        alu_op_o            : out std_ulogic_vector(ALU_OP_WIDTH-1 downto 0);
        sel_mem_addr_o      : out std_ulogic;
        incr_pc_o           : out std_ulogic;
        write_mem_o         : out std_ulogic;
        load_pc_reg_o       : out std_ulogic;
        load_instr_reg_o    : out std_ulogic;
        load_mem_addr_reg_o : out std_ulogic;
        load_mem_data_reg_o : out std_ulogic;
        load_acc_reg_o      : out std_ulogic;
        load_neg_zero_reg_o : out std_ulogic;

        done_o              : out std_ulogic
    );
end control;

architecture rtl of control is
    signal state, next_state    : std_ulogic_vector(STATE_WIDTH-1 downto 0);
    signal negative, zero       : std_ulogic;
begin
    negative <= neg_zero_reg_i(1);
    zero <= neg_zero_reg_i(0);

    instr_alu_decode: process(instr_reg_i)
    begin
        case instr_reg_i is
            when INSTR_ADD      => alu_op_o <= ALU_ADD;
            when INSTR_SUB      => alu_op_o <= ALU_SUB;
            when INSTR_SHIFT_R  => alu_op_o <= ALU_SHIFT_R;
            when INSTR_SHIFT_L  => alu_op_o <= ALU_SHIFT_L;
            when INSTR_AND      => alu_op_o <= ALU_AND;
            when INSTR_OR       => alu_op_o <= ALU_OR;
            when INSTR_XOR      => alu_op_o <= ALU_XOR;
            when INSTR_NOT      => alu_op_o <= ALU_NOT;
            when INSTR_LDA      => alu_op_o <= ALU_OP_ID;
            when others         => alu_op_o <= ALU_ADD;
        end case;
    end process instr_alu_decode;

    control_states: process(state, start_i, instr_reg_i, zero, negative)
    begin
        done_o <= '0';

        sel_mem_addr_o <= '0';
        incr_pc_o <= '0';
        write_mem_o <= '0';

        load_pc_reg_o <= '0';
        load_instr_reg_o <= '0';
        load_mem_addr_reg_o <= '0';
        load_mem_data_reg_o <= '0';
        load_acc_reg_o <= '0';
        load_neg_zero_reg_o <= '0';

        case state is
            when STATE_INIT =>
                if start_i = '1' then next_state <= STATE_FETCH_1; else next_state <= STATE_INIT; end if;
            when STATE_FETCH_1 =>
                load_mem_addr_reg_o <= '1';
                next_state <= STATE_FETCH_2;
            when STATE_FETCH_2 =>
                load_mem_data_reg_o <= '1';
                incr_pc_o <= '1';
                next_state <= STATE_FETCH_3;
            when STATE_FETCH_3 =>
                load_instr_reg_o <= '1';
                next_state <= STATE_DECODE_EXECUTE;
            when STATE_DECODE_EXECUTE =>
                case instr_reg_i is
                    when INSTR_NOP =>
                        next_state <= STATE_FETCH_1;
                    when INSTR_NOT =>
                        load_acc_reg_o <= '1';
                        load_neg_zero_reg_o <= '1';
                        next_state <= STATE_FETCH_1;
                    when INSTR_JMP =>
                        load_mem_addr_reg_o <= '1';
                        next_state <= STATE_JMP_1;
                    when INSTR_JZ =>
                        if zero = '1' then load_mem_addr_reg_o <= '1'; else load_mem_addr_reg_o <= '0'; end if;
                        if zero = '0' then incr_pc_o <= '1'; else incr_pc_o <= '0'; end if;
                        if zero = '1' then next_state <= STATE_JMP_1; else next_state <= STATE_FETCH_1; end if;
                    when INSTR_JN =>
                        if negative = '1' then load_mem_addr_reg_o <= '1'; else load_mem_addr_reg_o <= '0'; end if;
                        if negative = '0' then incr_pc_o <= '1'; else incr_pc_o <= '0'; end if;
                        if negative = '1' then next_state <= STATE_JMP_1; else next_state <= STATE_FETCH_1; end if;
                    when INSTR_HLT =>
                        done_o <= '1';
                        next_state <= STATE_END;
                    when others =>
                        load_mem_addr_reg_o <= '1';
                        next_state <= STATE_EXECUTE_1;
                end case;
            when STATE_EXECUTE_1 =>
                incr_pc_o <= '1';
                next_state <= STATE_EXECUTE_2;
            when STATE_EXECUTE_2 =>
                sel_mem_addr_o <= '1';
                load_mem_addr_reg_o <= '1';
                next_state <= STATE_EXECUTE_3;
            when STATE_EXECUTE_3 =>
                load_mem_data_reg_o <= '1';
                next_state <= STATE_EXECUTE_4;
            when STATE_EXECUTE_4 =>
                if instr_reg_i = instr_sta then
                    write_mem_o <= '1';
                else
                    load_acc_reg_o <= '1';
                    load_neg_zero_reg_o <= '1';
                end if;
                next_state <= STATE_FETCH_1;
            when STATE_JMP_1 =>
                load_mem_data_reg_o <= '1';
                next_state <= STATE_JMP_2;
            when STATE_JMP_2 =>
                load_pc_reg_o <= '1';
                next_state <= STATE_FETCH_1;
            when STATE_END =>
                done_o <= '1';
                if start_i = '1' then next_state <= STATE_FETCH_1; else next_state <= STATE_END; end if;
            when others =>
                next_state <= STATE_INIT;
        end case;
    end process control_states;

    control_sequential: process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            state <= STATE_INIT;
        elsif rising_edge(clk_i) then
            state <= next_state;
        end if;
    end process control_sequential;

end rtl;

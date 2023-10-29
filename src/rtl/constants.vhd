library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package constants is
    constant BIT_WIDTH      : integer := 8;
    constant MEMORY_SIZE    : integer := 512;

    type mem_t is array (0 to MEMORY_SIZE-1) of std_ulogic_vector(BIT_WIDTH-1 downto 0);
    type mem_file_t is file of character;

    constant INSTR_WIDTH    : integer := 4;
    constant INSTR_NOP      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0000";
    constant INSTR_STA      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0001";
    constant INSTR_LDA      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0010";
    constant INSTR_ADD      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0011";
    constant INSTR_OR       : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0100";
    constant INSTR_AND      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0101";
    constant INSTR_NOT      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0110";
    constant INSTR_XOR      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "0111";
    constant INSTR_JMP      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "1000";
    constant INSTR_JN       : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "1001";
    constant INSTR_JZ       : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "1010";
    constant INSTR_SUB      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "1011";
    constant INSTR_SHIFT_R  : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "1100";
    constant INSTR_SHIFT_L  : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "1101";
    constant INSTR_HLT      : std_ulogic_vector(INSTR_WIDTH-1 downto 0) := "1111";

    constant ALU_OP_WIDTH   : integer := 4;
    constant ALU_ADD        : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0000";
    constant ALU_OR         : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0001";
    constant ALU_AND        : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0010";
    constant ALU_NOT        : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0011";
    constant ALU_XOR        : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0100";
    constant ALU_OP_ID      : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0101";
    constant ALU_SUB        : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0110";
    constant ALU_SHIFT_R    : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "0111";
    constant ALU_SHIFT_L    : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0) := "1000";

    constant STATE_WIDTH            : integer := 4;
    constant STATE_INIT             : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "0000";
    constant STATE_FETCH_1          : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "0001";
    constant STATE_FETCH_2          : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "0011";
    constant STATE_FETCH_3          : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "0111";
    constant STATE_DECODE_EXECUTE   : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "1111";
    constant STATE_EXECUTE_1        : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "1110";
    constant STATE_EXECUTE_2        : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "1100";
    constant STATE_EXECUTE_3        : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "1000";
    constant STATE_EXECUTE_4        : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "1010";
    constant STATE_JMP_1            : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "1011";
    constant STATE_JMP_2            : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "1001";
    constant STATE_END              : std_ulogic_vector(STATE_WIDTH-1 downto 0) := "0101";
end constants;

package body constants is

end constants;

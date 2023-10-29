library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library yani;
use yani.constants.all;

entity top is
    generic (
        MEMORY_IMAGE_FILE_PATH  : string
    );
    port (
        clk_i   : in std_ulogic;
        rst_i   : in std_ulogic;
        start_i : in std_ulogic;

        done_o  : out std_ulogic
    );
end top;

architecture rtl of top is

    component alu is
        port (
            alu_op_i    : in std_ulogic_vector(ALU_OP_WIDTH-1 downto 0);
            acc_i       : in std_ulogic_vector(BIT_WIDTH-1 downto 0);
            mem_i       : in std_ulogic_vector(BIT_WIDTH-1 downto 0);

            alu_res_o   : out std_ulogic_vector(BIT_WIDTH-1 downto 0);
            alu_zero_o  : out std_ulogic;
            alu_neg_o   : out std_ulogic
        );
    end component;

    component control is
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
    end component;

    component memory is
        generic (
            MEM_FILE_PATH   : string;
            MEM_SIZE        : integer
        );
        port (
            rst_i   : in std_ulogic;
            addr_i  : in std_ulogic_vector(BIT_WIDTH-1 downto 0);
            data_i  : in std_ulogic_vector(BIT_WIDTH-1 downto 0);
            write_i : in std_ulogic;

            mem_o   : out std_ulogic_vector(BIT_WIDTH-1 downto 0)
        );
    end component;

    signal alu_op               : std_ulogic_vector(ALU_OP_WIDTH-1 downto 0);
    signal mem_output           : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal mux_mem_addr_output  : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal mux_mem_data_output  : std_ulogic_vector(BIT_WIDTH-1 downto 0);

    signal alu_res              : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal alu_zero             : std_ulogic;
    signal alu_neg              : std_ulogic;

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

    signal pc_reg               : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal acc_reg              : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal instr_reg            : std_ulogic_vector(INSTR_WIDTH-1 downto 0);
    signal mem_addr_reg         : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal mem_data_reg         : std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal neg_zero_reg         : std_ulogic_vector(1 downto 0);
begin

    alu_inst: entity yani.alu port map (
        alu_op_i    => alu_op,
        acc_i       => acc_reg,
        mem_i       => mem_data_reg,

        alu_res_o   => alu_res,
        alu_zero_o  => alu_zero,
        alu_neg_o   => alu_neg
    );

    control_inst: entity yani.control port map (
        clk_i               => clk_i,
        rst_i               => rst_i,
        start_i             => start_i,

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

        done_o              => done_o
    );

    registers: process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            pc_reg          <= (others => '0');
            acc_reg         <= (others => '0');
            instr_reg       <= (others => '0');
            mem_addr_reg    <= (others => '0');
            mem_data_reg    <= (others => '0');
            neg_zero_reg    <= (others => '0');
        elsif rising_edge(clk_i) then
            if incr_pc = '1' then
                pc_reg <= std_ulogic_vector(unsigned(pc_reg) + 1);
            elsif load_pc_reg = '1' then
                pc_reg <= mem_data_reg;
            else
                pc_reg <= pc_reg;
            end if;

            if load_acc_reg = '1' then
                acc_reg <= alu_res;
            else
                acc_reg <= acc_reg;
            end if;

            if load_instr_reg = '1' then
                instr_reg <= mem_data_reg(BIT_WIDTH-1 downto INSTR_WIDTH);
            else
                instr_reg <= instr_reg;
            end if;

            if load_mem_addr_reg = '1' then
                mem_addr_reg <= mux_mem_addr_output;
            else
                mem_addr_reg <= mem_addr_reg;
            end if;

            if load_mem_data_reg = '1' then
                mem_data_reg <= mux_mem_data_output;
            else
                mem_data_reg <= mem_data_reg;
            end if;

            if load_neg_zero_reg = '1' then
                neg_zero_reg <= alu_neg & alu_zero;
            else
                neg_zero_reg <= neg_zero_reg;
            end if;
        end if;
    end process registers;

    memory_inst: entity yani.memory generic map (
        MEM_SIZE        => MEMORY_SIZE,
        MEM_FILE_PATH   => MEMORY_IMAGE_FILE_PATH
    )
    port map (
        rst_i   => rst_i,
        addr_i  => mem_addr_reg,
        data_i  => mem_data_reg,
        write_i => write_mem,

        mem_o   => mem_output
    );

    mux_mem_addr_output <= mem_data_reg when (sel_mem_addr = '1') else pc_reg;

    mux_mem_data_output <= acc_reg when (sel_mem_data = '1') else mem_output;
end rtl;

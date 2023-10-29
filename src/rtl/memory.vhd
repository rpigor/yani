library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

library yani;
use yani.constants.all;

entity memory is
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
end entity memory;

architecture rtl of memory is
    signal mem : mem_t;
begin
    ram: process(rst_i, write_i, addr_i, data_i)
        file mem_file           : mem_file_t;
        variable word           : character;
        constant header_error   : string := "Invalid memory image header. Memory image should begin with x""03_4E_44_52"".";
    begin
        if rst_i = '1' then
            file_open(mem_file, MEM_FILE_PATH, READ_MODE);
            assert not endfile(mem_file) report "Empty memory image.";
            read(mem_file, word);
            assert to_unsigned(character'pos(word), 8) = 16#03# and not endfile(mem_file) report header_error;
            read(mem_file, word);
            assert word = 'N' and not endfile(mem_file) report header_error;
            read(mem_file, word);
            assert word = 'D' and not endfile(mem_file) report header_error;
            read(mem_file, word);
            assert word = 'R' report header_error;
            for i in 0 to MEM_SIZE-1 loop
                if not endfile(mem_file) then
                    read(mem_file, word);
                    mem(i) <= std_ulogic_vector(to_unsigned(character'pos(word), 8));
                    assert not endfile(mem_file) report "Memory image is not 16-bit aligned.";
                    read(mem_file, word);
                else
                    mem(i) <= (others => '0');
                end if;
            end loop;
            assert endfile(mem_file) report "Memory image does not fit into memory of " & integer'image(MEM_SIZE) & " bytes.";
            file_close(mem_file);
        elsif write_i = '1' then
            mem(to_integer(unsigned(addr_i))) <= data_i;
        end if;
    end process ram;

    mem_o <= mem(to_integer(unsigned(addr_i)));
end rtl;

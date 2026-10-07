library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender is
    generic (
            WIDTH   : integer := 32;
            W_IMM1  : integer := 12;
            W_IMM2  : integer := 20);
    port (
            i_se    : in std_logic;  -- sign extend 12-bit (I-type, S-type, B-type)
            i_se20  : in std_logic;  -- sign extend 20-bit (JAL)
            i_ze    : in std_logic;  -- zero extend
            i_za    : in std_logic;  -- zero append (LUI)
            i_imm12 : in std_logic_vector((W_IMM1-1) downto 0);
            i_imm20 : in std_logic_vector((W_IMM2-1) downto 0);
            o_ext   : out std_logic_vector((WIDTH-1) downto 0)
    );
end extender;

architecture dataflow of extender is
begin

    process(i_se, i_se20, i_ze, i_za, i_imm12, i_imm20)
    begin
        if i_se = '1' then
            -- Sign extend 12-bit - I,S,B type instructions
            o_ext <= std_logic_vector(resize(signed(i_imm12), WIDTH));
            
        elsif i_se20 = '1' then
            -- Sign extend 20-bit - JAL
            o_ext <= std_logic_vector(resize(signed(i_imm20), WIDTH));
            
        elsif i_ze = '1' then
            -- Zero extend 12-bit - SLTIU
            o_ext <= std_logic_vector(resize(unsigned(i_imm12), WIDTH));
            
        elsif i_za = '1' then
            -- Zero append (shift left 12 bits) - LUI, AUIPC
            o_ext <= i_imm20 & x"000";
            
        else
            -- Default
            o_ext <= (others => '0');
        end if;
    end process;

end dataflow;
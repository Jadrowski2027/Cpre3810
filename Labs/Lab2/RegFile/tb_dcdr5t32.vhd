library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dcdr5t32 is
  generic(gCLK_HPER   : time := 50 ns;
          DATA_WIDTH_IN   : integer := 5;
          DATA_WIDTH_OUT  : integer := 32);
end tb_dcdr5t32;


architecture mixed of tb_dcdr5t32 is

  constant cCLK_PER  : time := gCLK_HPER * 2;


  component dcdr5t32
    generic(WIDTH_IN : integer := DATA_WIDTH_IN;
            WIDTH_OUT : integer := DATA_WIDTH_OUT);
    port(
         i_sel : in std_logic_vector(WIDTH_IN-1 downto 0);
         o_out : out std_logic_vector(WIDTH_OUT-1 downto 0));
  end component;

  signal s_sel : std_logic_vector(DATA_WIDTH_IN-1 downto 0);
  signal s_out : std_logic_vector(DATA_WIDTH_OUT-1 downto 0);

begin

  DUT: dcdr5t32
  port map(i_sel => s_sel,
           o_out => s_out);

  P_TB: process
  begin
    s_sel <= b"00000";
    wait for cCLK_PER;
    s_sel <= b"00001";
    wait for cCLK_PER;
    s_sel <= b"00010";
    wait for cCLK_PER;
    s_sel <= b"00011";
    wait for cCLK_PER;
    s_sel <= b"00100";
    wait for cCLK_PER;
    s_sel <= b"00101";
    wait for cCLK_PER;
    s_sel <= b"00110";
    wait for cCLK_PER;
    s_sel <= b"00111";
    wait for cCLK_PER;
    s_sel <= b"01000";
    wait for cCLK_PER;
    s_sel <= b"01001";
    wait for cCLK_PER;
    s_sel <= b"01010";
    wait for cCLK_PER;
    s_sel <= b"01011";
    wait for cCLK_PER;
    s_sel <= b"01100";
    wait for cCLK_PER;
    s_sel <= b"01101";
    wait for cCLK_PER;
    s_sel <= b"01110";
    wait for cCLK_PER;
    s_sel <= b"01111";
    wait for cCLK_PER;
    s_sel <= b"10000";
    wait for cCLK_PER;
    s_sel <= b"10001";
    wait for cCLK_PER;
    s_sel <= b"10010";
    wait for cCLK_PER;
    s_sel <= b"10011";
    wait for cCLK_PER;
    s_sel <= b"10100";
    wait for cCLK_PER;
    s_sel <= b"10101";
    wait for cCLK_PER;
    s_sel <= b"10110";
    wait for cCLK_PER;
    s_sel <= b"10111";
    wait for cCLK_PER;
    s_sel <= b"11000";
    wait for cCLK_PER;
    s_sel <= b"11001";
    wait for cCLK_PER;
    s_sel <= b"11010";
    wait for cCLK_PER;
    s_sel <= b"11011";
    wait for cCLK_PER;
    s_sel <= b"11100";
    wait for cCLK_PER;
    s_sel <= b"11101";
    wait for cCLK_PER;
    s_sel <= b"11110";
    wait for cCLK_PER;
    s_sel <= b"11111";
    wait for cCLK_PER;

    wait;
  end process;

end mixed;

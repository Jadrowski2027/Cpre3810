
library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_arr.all;

entity tb_mux32t1_n is
  generic(gCLK_HPER   : time := 50 ns;
          DATA_WIDTH_SEL : integer := 5;
          NUM_CH         : integer := 32;
          DATA_WIDTH  : integer := 32);
end tb_mux32t1_n;


architecture mixed of tb_mux32t1_n is

  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mux32t1_n
    generic(
        N           : integer := NUM_CH;
        SEL   : integer := DATA_WIDTH_SEL;
        WIDTH       : integer := DATA_WIDTH);
    port(
         i_sel : in std_logic_vector(SEL-1 downto 0);
         i_array  : in vector_array(N-1 downto 0)(WIDTH - 1 downto 0);
         o_O : out std_logic_vector(WIDTH - 1 downto 0));
  end component;

  signal s_sel : std_logic_vector(DATA_WIDTH_SEL-1 downto 0);
  signal s_in : vector_array(NUM_CH-1 downto 0)(DATA_WIDTH - 1 downto 0);
  signal s_out : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

  DUT: mux32t1_n
  port map(i_sel => s_sel,
           i_array => s_in,
           o_O => s_out);

  P_TB: process
  begin
    s_in <= (0  => x"00000000", 1  => x"00000001", 2  => x"00000002", 3  => x"00000003",
         4  => x"00000004", 5  => x"00000005", 6  => x"00000006", 7  => x"00000007",
         8  => x"00000008", 9  => x"00000009", 10 => x"0000000A", 11 => x"0000000B",
         12 => x"0000000C", 13 => x"0000000D", 14 => x"0000000E", 15 => x"0000000F",
         16 => x"00000010", 17 => x"00000011", 18 => x"00000012", 19 => x"00000013",
         20 => x"00000014", 21 => x"00000015", 22 => x"00000016", 23 => x"00000017",
         24 => x"00000018", 25 => x"00000019", 26 => x"0000001A", 27 => x"0000001B",
         28 => x"0000001C", 29 => x"0000001D", 30 => x"0000001E", 31 => x"0000001F");
    s_sel <= b"00000";
    wait for cCLK_PER;
    s_sel <= b"00001";
    wait for cCLK_PER;
    s_sel <= b"10001";
    wait for cCLK_PER;
    s_sel <= b"10010";
    wait for cCLK_PER;
    s_sel <= b"10011";
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
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux32t1 is
  generic(gCLK_HPER   : time := 50 ns;
          DATA_WIDTH_SEL   : integer := 5;
          DATA_WIDTH_IN  : integer := 32);
end tb_mux32t1;


architecture mixed of tb_mux32t1 is

  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mux32t1
    generic(
        WIDTH_SEL   : integer := DATA_WIDTH_SEL;
        NUM_INPUTS  : integer := DATA_WIDTH_IN);
    port(
         i_sel : in std_logic_vector(WIDTH_SEL-1 downto 0);
         i_inputs  : in std_logic_vector(NUM_INPUTS-1 downto 0);
         o_out : out std_logic);
  end component;

  signal s_sel : std_logic_vector(DATA_WIDTH_SEL-1 downto 0);
  signal s_in : std_logic_vector(DATA_WIDTH_IN-1 downto 0);
  signal s_out : std_logic;

begin

  DUT: mux32t1
  port map(i_sel => s_sel,
           i_inputs => s_in,
           o_out => s_out);

  P_TB: process
  begin
    s_sel <= b"00000";
    s_in  <= x"04080401";
    wait for cCLK_PER;
    s_sel <= b"00001";
    s_in  <= x"04080401";
    wait for cCLK_PER;
    s_sel <= b"10001";
    s_in  <= x"04080401";
    wait for cCLK_PER;
    s_sel <= b"10010";
    s_in  <= x"04080401";
    wait for cCLK_PER;
    s_sel <= b"10011";
    s_in  <= x"04080401";
    wait for cCLK_PER;
    s_sel <= b"11100";
    s_in  <= x"04080401";
    wait for cCLK_PER;
    s_sel <= b"11101";
    s_in  <= x"04080401";
    wait for cCLK_PER;
    s_sel <= b"11110";
    s_in  <= x"84080401";
    wait for cCLK_PER;
    s_sel <= b"11111";
    s_in  <= x"84080401";
    wait for cCLK_PER;

    wait;
  end process;

end mixed;
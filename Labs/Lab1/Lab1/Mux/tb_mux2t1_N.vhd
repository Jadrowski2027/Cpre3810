library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_mux2t1_N is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 16);   -- Generic for half of the clock cycle period
end tb_mux2t1_N;

architecture mixed of tb_mux2t1_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component mux2t1_N is
  generic(N : integer := DATA_WIDTH);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

signal s_iS : std_logic := '0';
signal s_D0   : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_D1   : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_oO   : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: mux2t1_N
  generic map (N => DATA_WIDTH)
  port map(
            i_S => s_iS,
            i_D0 => s_D0,
            i_D1 => s_D1,
            o_O => s_oO);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html


  
P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    -- Initialize weight value to 10.
    s_iS   <= '0';  
    s_D0   <= x"0ADF";
    s_D1 <= x"1E54";
    wait for gCLK_HPER*2;
    -- Test case 2:
    s_iS   <= '1';  
    s_D0   <= x"2F63";
    s_D1 <= x"1E54";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Test case 3:
    s_iS   <= '1';  
    s_D0   <= x"0ADF";
    s_D1 <= x"0381";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Test case 4:
    s_iS   <= '0';  
    s_D0   <= x"1022";
    s_D1 <= x"1E54";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait;
  end process;

end mixed;
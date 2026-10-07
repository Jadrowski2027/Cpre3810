library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_onescomp is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_onescomp;

architecture mixed of tb_onescomp is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component onescomp is
  generic(N : integer := DATA_WIDTH);
  port(iA         : in std_logic_vector(N-1 downto 0);
       oO          : out std_logic_vector(N-1 downto 0));
end component;



signal s_iA   : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_oO   : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: onescomp
  generic map (N => DATA_WIDTH)
  port map(
            iA => s_iA,
            oO => s_oO);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html


  
P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    -- Initialize weight value to 10.
    s_iA   <= x"FF00000F";  
   
    wait for gCLK_HPER*2;
    -- Test case 2:
  
    s_iA <= x"F0F0F0F0";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Test case 3:
  
    s_iA <= x"00FF0F00";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Test case 4:
   
    s_iA <= x"F00FFFF0";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait;
  end process;

end mixed;
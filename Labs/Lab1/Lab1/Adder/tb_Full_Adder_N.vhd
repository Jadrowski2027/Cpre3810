library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_Full_Adder_N is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_Full_Adder_N;

architecture mixed of tb_Full_Adder_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component Full_Adder_N is
  generic(N : integer := DATA_WIDTH);
  port(iCLK           : in std_logic;
       i_Cin       : in std_logic;
       i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_S         : out std_logic_vector(N-1 downto 0);
       o_Cout      : out std_logic);

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset    : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_A      : std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";
signal s_B      : std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";
signal s_Cin    : std_logic := '0';
signal s_oO   : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_Cout     : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: Full_Adder_N
  generic map (N => DATA_WIDTH)
  port map(
            iCLK     => CLK,
            i_Cin    => s_Cin,
            i_A      => s_A,
            i_B      => s_B,
            o_O      => s_oO,
            o_Cout   => s_Cout);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    s_A   <= x"000000FF";  
    s_B   <= x"00000001"; 
    s_Cin <= '1';
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;

    -- Test case 2:
    s_A   <= x"52373400";  
    s_B   <= x"80030560"; 
    s_Cin <= '1';
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expect: o_Y output signal to be 55 = 3*10+25 and o_X output signal to be 3 after two positive edge of clock.

    -- Test case 3:
    s_A   <= x"23053804";  
    s_B   <= x"20437000"; 
    s_Cin <= '1';
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;

    wait;
  end process;

end mixed;

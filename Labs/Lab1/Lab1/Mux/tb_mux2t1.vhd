library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_mux2t1 is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 8);   -- Generic for half of the clock cycle period
end tb_mux2t1;

architecture mixed of tb_mux2t1 is 

constant cCLK_PER   : time := gCLK_HPER * 2;


component mux2t1 is
    port(
        iA               : in std_logic;
        iB               : in std_logic;
        s0               : in std_logic;
        oC               : out std_logic);
end component;
signal CLK, reset : std_logic := '0';
signal s_iA : std_logic := '0';
signal s_iB : std_logic := '0';
signal s_s0 : std_logic := '0';
signal s_oC : std_logic; 

begin

    DUT0: mux2t1
    port map(
        iA => s_iA,
        iB => s_iB,
        s0 => s_s0,
        oC => s_oC);
    
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
        s_s0 <= '0';
        s_iA <= '0';
        s_iB <= '0';
        wait for gCLK_HPER*2;
        s_s0 <= '0';
        s_iA <= '0';
        s_iB <= '1';
        wait for gCLK_HPER*2;
        s_s0 <= '0';
        s_iA <= '1';
        s_iB <= '1';
        wait for gCLK_HPER*2;
        s_s0 <= '0';
        s_iA <= '1';
        s_iB <= '0';
        wait for gCLK_HPER*2;
        s_s0 <= '1';
        s_iA <= '0';
        s_iB <= '0';
        wait for gCLK_HPER*2;
        s_s0 <= '1';
        s_iA <= '0';
        s_iB <= '1';
        wait for gCLK_HPER*2;
        s_s0 <= '1';
        s_iA <= '1';
        s_iB <= '1';
        wait for gCLK_HPER*2;
        s_s0 <= '1';
        s_iA <= '1';
        s_iB <= '0';
        wait for gCLK_HPER*2;

        wait;
  end process;

end mixed;


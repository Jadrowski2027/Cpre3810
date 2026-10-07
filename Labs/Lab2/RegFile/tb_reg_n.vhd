library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg_n is
  generic(gCLK_HPER   : time := 50 ns;
          DATA_WIDTH  : integer := 32);
end tb_reg_n;

architecture mixed of tb_reg_n is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component reg_n
    generic(WIDTH : integer := DATA_WIDTH);
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_Din        : in std_logic_vector(WIDTH-1 downto 0);     -- Data value input
         o_Dout       : out std_logic_vector(WIDTH-1 downto 0));   -- Data value output
  end component;

  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_Din, s_Dout : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  DUT: reg_n 
  port map(i_CLK  => s_CLK,
           i_RST  => s_RST,
           i_WE   => s_WE,
           i_Din  => s_Din,
           o_Dout => s_Dout);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- Reset the FF
    s_RST <= '1';
    s_WE  <= '0';
    s_Din   <= x"F0F0F0FF";
    wait for cCLK_PER;

    -- Store '1'
    s_RST <= '0';
    s_WE  <= '1';
    s_Din   <= x"FFFFFFFF";
    wait for cCLK_PER;  

    -- Keep '1'
    s_RST <= '0';
    s_WE  <= '0';
    s_Din   <= x"00000000";
    wait for cCLK_PER;  

    -- Store '0'    
    s_RST <= '0';
    s_WE  <= '1';
    s_Din   <= x"00000000";
    wait for cCLK_PER;  

    -- Keep '0'
    s_RST <= '0';
    s_WE  <= '0';
    s_Din   <= x"FFFFFFFF";
    wait for cCLK_PER;  

    wait;
  end process;
  
end mixed;

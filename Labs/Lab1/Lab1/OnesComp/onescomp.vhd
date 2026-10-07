library IEEE;
use IEEE.std_logic_1164.all;

entity onescomp is
  generic(N : integer); -- Generic of type integer for input/output data width. Default value is 32.
  port(iA         : in std_logic_vector(N-1 downto 0);
       oO          : out std_logic_vector(N-1 downto 0));

end onescomp;

architecture structural of onescomp is

  component invg is 
    port(i_A                  : in std_logic;
         o_F                : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_INV: for i in 0 to N-1 generate
    INVI: invg port map(
              i_A     => iA(i),  
              o_F     => oO(i));  
 
  end generate G_NBit_INV;
  
end structural;
library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
  generic(WIDTH : integer);
  port(nadd_sub    : in std_logic;
       alu_src     : in std_logic;
       i_imm       : in std_logic_vector(WIDTH-1 downto 0);
       i_A         : in std_logic_vector(WIDTH-1 downto 0);
       i_B         : in std_logic_vector(WIDTH-1 downto 0);
       o_S         : out std_logic_vector(WIDTH-1 downto 0);
       o_Cout      : out std_logic);
end ALU;

architecture mixed of ALU is
    component xorg2 is 
        port(i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);
    end component; 
    
    component Full_Adder_N is 
        generic(N : integer := WIDTH);
        port(i_Cin  : in std_logic;
            i_A    : in std_logic_vector(N-1 downto 0);
            i_B    : in std_logic_vector(N-1 downto 0);
            o_S    : out std_logic_vector(N-1 downto 0);
            o_Cout : out std_logic);
    end component;

    component mux2t1_N is
        generic(N : integer := WIDTH); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_S          : in std_logic;
            i_D0         : in std_logic_vector(N-1 downto 0);
            i_D1         : in std_logic_vector(N-1 downto 0);
            o_O          : out std_logic_vector(N-1 downto 0));

    end component;
    
    signal s_Bmux : std_logic_vector(WIDTH-1 downto 0);
    signal s_Bxor : std_logic_vector(WIDTH-1 downto 0);

begin
    G_MUX: mux2t1_N
        generic map(N => WIDTH)
        port map(i_S => alu_src,
                 i_D0 => i_B,
                 i_D1 => i_imm,
                 o_O => s_Bmux);
    G_NBit_XOR: for i in 0 to WIDTH-1 generate
        XORI: xorg2 port map (i_A => s_Bmux(i), i_B => nadd_sub, o_F => s_Bxor(i));
    end generate G_NBit_XOR;

    G_Nbit_FADD: Full_Adder_N 
        generic map(N => WIDTH)
        port map(i_Cin => nadd_sub, 
                i_A => i_A, 
                i_B => s_Bxor, 
                o_S => o_S, 
                o_Cout => o_Cout);
        
end mixed;

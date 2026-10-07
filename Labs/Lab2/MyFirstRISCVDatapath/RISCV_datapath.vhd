library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_arr.all;


entity riscv_datpat is
    generic(
        WR_SEL  : integer;
        RD_SEL  : integer;
        DATA_WIDTH   : integer;
        NUM_REG : integer
    );
    port(
        CLK     : in std_logic;
        RST     : in std_logic;
        RegWr      : in std_logic;
        naddsub : in std_logic;
        ALUSrc  : in std_logic;
        RD   : in std_logic_vector(WR_SEL-1 downto 0);
        RS1  : in std_logic_vector(RD_SEL-1 downto 0);
        RS2  : in std_logic_vector(RD_SEL-1 downto 0);
        IMM  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        OVF : out std_logic);
end riscv_datpat;

architecture structural of riscv_datpat is

    component ALU is
        generic(WIDTH : integer);
        port(nadd_sub    : in std_logic;
            alu_src     : in std_logic;
            i_imm       : in std_logic_vector(WIDTH-1 downto 0);
            i_A         : in std_logic_vector(WIDTH-1 downto 0);
            i_B         : in std_logic_vector(WIDTH-1 downto 0);
            o_S         : out std_logic_vector(WIDTH-1 downto 0);
            o_Cout      : out std_logic);
    end component;

    component regfile is
        generic(
        WR_SEL  : integer;
        RD_SEL  : integer;
        DATA_WIDTH   : integer;
        NUM_REG : integer
    );
    port(
        iCLK     : in std_logic;
        iRST     : in std_logic;
        iWE      : in std_logic;
        wr_sele   : in std_logic_vector(WR_SEL-1 downto 0);
        rd_sel1  : in std_logic_vector(RD_SEL-1 downto 0);
        rd_sel2  : in std_logic_vector(RD_SEL-1 downto 0);
        i_Din    : in std_logic_vector(DATA_WIDTH-1 downto 0);
        o_Dout1  : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_Dout2  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
    end component;

    component mux2t1_N is
        generic(N : integer); 
        port(i_S          : in std_logic;
            i_D0         : in std_logic_vector(N-1 downto 0);
            i_D1         : in std_logic_vector(N-1 downto 0);
            o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component andg2 is 
        port(i_A          : in std_logic;
            i_B          : in std_logic;
            o_F          : out std_logic);
    end component;

    signal Read1 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal Read2 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ALU_A : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal MUX2_out: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ALU_out: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ADD1_out: std_logic;
    


begin

    G_RICV_REG: regfile
        generic map(
            WR_SEL => WR_SEL,
            RD_SEL => RD_SEL,
            DATA_WIDTH => DATA_WIDTH,
            NUM_REG => NUM_REG)
        port map(
            iCLK => CLK,
            iRST => RST,
            iWE => RegWr,
            wr_sele => RD,
            rd_sel1 => RS1,
            rd_sel2 => RS2,
            i_Din => ALU_out,
            o_Dout1 => Read1,
            o_Dout2 => Read2);
    
    G_AND1: andg2
        port map(
            i_A => ALUSrc,
            i_B => naddsub,
            o_F => ADD1_out);
    

    G_MUX1: mux2t1_N
        generic map(N => DATA_WIDTH)
        port map(
            i_S => ADD1_out,
            i_D0 => Read1,
            i_D1 => IMM,
            o_O => ALU_A);
    G_MUX2: mux2t1_N
        generic map(N => DATA_WIDTH)
        port map(
            i_S => ADD1_out,
            i_D0 => IMM,
            i_D1 => (others => '0'),
            o_O => MUX2_out);

    G_ALU: ALU
        generic map(WIDTH => DATA_WIDTH)
        port map(
            nadd_sub => naddsub,
            alu_src => ALUSrc,
            i_imm => MUX2_out,
            i_A => ALU_A,
            i_B => Read2,
            o_S => ALU_out,
            o_Cout => OVF);
end structural;
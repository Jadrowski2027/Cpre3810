library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_arr.all;


entity riscv_datpat2 is
    generic(
        WR_SEL  : integer;
        RD_SEL  : integer;
        DATA_WIDTH   : integer;
        W_MEMADDR : integer;
        W_IM12  : integer;
        W_IM20  : integer;
        WBYTE : integer;
        NUM_REG : integer
    );
    port(
        CLK     : in std_logic;
        RST     : in std_logic;
        i_we     : in std_logic;
        naddsub : in std_logic;
        ALUSrc  : in std_logic;
        ilw     : in std_logic;
        isw     : in std_logic;
        ise     : in std_logic;
        ise20   : in std_logic;
        ize     : in std_logic;
        iza     : in std_logic;
        ibe     : in std_logic_vector(3 downto 0) := "1111";
        RD   : in std_logic_vector(WR_SEL-1 downto 0);
        RS1  : in std_logic_vector(RD_SEL-1 downto 0);
        RS2  : in std_logic_vector(RD_SEL-1 downto 0);
        IMM12  : in std_logic_vector(W_IM12-1 downto 0);
        IMM20  : in std_logic_vector(W_IM20-1 downto 0);
        OVF : out std_logic);
end riscv_datpat2;

architecture structural of riscv_datpat2 is

    component mem is
            generic 
        (
            DATA_WIDTH : natural := DATA_WIDTH;
            ADDR_WIDTH : natural := W_MEMADDR;
            BYTE_WIDTH : natural := WBYTE
        );

        port 
        (
            clk        : in std_logic;
            addr            : in std_logic_vector((ADDR_WIDTH-1) downto 0);
            data            : in std_logic_vector((DATA_WIDTH-1) downto 0);
            be              : in std_logic_vector (3 downto 0);   -- 4 bytes per word
            we        : in std_logic := '1';
            q        : out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    end component;

    component extender is
        generic (
            WIDTH   : integer := DATA_WIDTH;
            W_IMM1  : integer := W_IM12;
            W_IMM2  : integer := W_IM20);
        port (
            i_se    : in std_logic;  -- sign extend 12-bit (I-type, S-type, B-type)
            i_se20  : in std_logic;  -- sign extend 20-bit (JAL)
            i_ze    : in std_logic;  -- zero extend
            i_za    : in std_logic;  -- zero append (LUI)
            i_imm12 : in std_logic_vector((W_IMM1-1) downto 0);
            i_imm20 : in std_logic_vector((W_IMM2-1) downto 0);
            o_ext   : out std_logic_vector((WIDTH-1) downto 0));
    end component;

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

    signal DataIn : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal DataBus : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ExtOut : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ALUOut: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal Read1 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal Read2 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal MemOut: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal AddOut: std_logic;
    


begin
    G_EXTEND: extender
        generic map(
            WIDTH => DATA_WIDTH,
            W_IMM1 => W_IM12,
            W_IMM2 => W_IM20)
        port map(
            i_se => ise,
            i_se20 => ise20,
            i_ze => ize,
            i_za => iza,
            i_imm12 => IMM12,
            i_imm20 => IMM20,
            o_ext => ExtOut);
    G_RICV_REG: regfile
        generic map(
            WR_SEL => WR_SEL,
            RD_SEL => RD_SEL,
            DATA_WIDTH => DATA_WIDTH,
            NUM_REG => NUM_REG)
        port map(
            iCLK => CLK,
            iRST => RST,
            iWE => i_we,
            wr_sele => RD,
            rd_sel1 => RS1,
            rd_sel2 => RS2,
            i_Din => DataIn,
            o_Dout1 => Read1,
            o_Dout2 => Read2);
    
    G_AND1: andg2
        port map(
            i_A => ALUSrc,
            i_B => naddsub,
            o_F => AddOut);

     G_MUX1: mux2t1_N
        generic map(N => DATA_WIDTH)
        port map(
            i_S => ilw,
            i_D0 => DataBus,
            i_D1 => MemOut,
            o_O => DataIn);   

    G_MUX2: mux2t1_N
        generic map(N => DATA_WIDTH)
        port map(
            i_S => AddOut,
            i_D0 => ALUOut,
            i_D1 => ExtOut,
            o_O => DataBus);

    G_MEM: mem
        generic map(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => W_MEMADDR,
            BYTE_WIDTH => WBYTE)
        port map(
            clk => CLK,
            addr => DataBus(11 downto 2),
            data => Read2,
            be => ibe,
            we => isw,
            q => MemOut);

    G_ALU: ALU
        generic map(WIDTH => DATA_WIDTH)
        port map(
            nadd_sub => naddsub,
            alu_src => ALUSrc,
            i_imm => ExtOut,
            i_A => Read1,
            i_B => Read2,
            o_S => ALUOut,
            o_Cout => OVF);
end structural;
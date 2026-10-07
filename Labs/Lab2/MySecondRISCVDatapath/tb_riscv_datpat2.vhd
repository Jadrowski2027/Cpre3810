library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_arr.all;

entity tb_riscv_datpat2 is
  generic(gCLK_HPER   : time := 20 ns;
          WR_SEL  : integer := 5;
          RD_SEL  : integer := 5;
          D_WIDTH   : integer := 32;
          W_MEMADD : integer := 10;
          WIMM12    : integer := 12;
          WIMM20    : integer := 20;
          WBYTE     : integer := 8;
          NUM_REG : integer := 32);
end tb_riscv_datpat2;


architecture mixed of tb_riscv_datpat2 is

  constant cCLK_PER  : time := gCLK_HPER * 2;


  component riscv_datpat2
    generic(
        WR_SEL   : integer := WR_SEL;
        RD_SEL   : integer := RD_SEL;
        DATA_WIDTH   : integer := D_WIDTH;
        W_MEMADDR : integer := W_MEMADD;
        W_IM12    : integer := WIMM12;
        W_IM20    : integer := WIMM20;
        WBYTE     : integer := WBYTE;
        NUM_REG : integer := NUM_REG);
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
        ibe     : in std_logic_vector(3 downto 0);
        RD   : in std_logic_vector(WR_SEL-1 downto 0);
        RS1  : in std_logic_vector(RD_SEL-1 downto 0);
        RS2  : in std_logic_vector(RD_SEL-1 downto 0);
        IMM12  : in std_logic_vector(W_IM12-1 downto 0);
        IMM20  : in std_logic_vector(W_IM20-1 downto 0);
        OVF : out std_logic);
    end component;

    signal s_CLK, s_RST, s_RWr, s_adsb, s_alusrc, s_ovf : std_logic;
    signal swe, ssw, slw, sse, sse20, sze, sza : std_logic;
    signal sbe : std_logic_vector(3 downto 0) := "1111";
    signal s_RD : std_logic_vector(WR_SEL-1 downto 0);
    signal s_rs1, s_rs2 : std_logic_vector(RD_SEL-1 downto 0);
    signal s_Imm12 : std_logic_vector(WIMM12 - 1 downto 0);
    signal s_Imm20 : std_logic_vector(WIMM20 - 1 downto 0);
    signal sovf    : std_logic;


begin

    DUT: riscv_datpat2
    port map(CLK => s_CLK,
            RST => s_RST,
            i_we => swe,
            naddsub => s_adsb,
            ALUSrc => s_alusrc,
            ilw => slw,
            isw =>ssw,
            ise => sse,
            ise20 => sse20,
            ize => sze,
            iza => sza,
            ibe => sbe,
            RD => s_RD,
            RS1 => s_rs1,
            RS2 => s_rs2,
            IMM12 => s_Imm12,
            IMM20 => s_Imm20,
            OVF => sovf);

    P_CLK: process
    begin
        s_CLK <= '0';
        wait for gCLK_HPER;
        s_CLK <= '1';
        wait for gCLK_HPER;
    end process;
            
    P_TB: process
begin
    -- Reset
    s_RST <= '1';
    swe <= '0';
    slw <= '0';
    ssw <= '0';
    sse <= '0';
    sse20 <= '0';
    sze <= '0';

    wait for cCLK_PER;
    s_RST <= '0';
    
-- lui x25, 0x10010
    swe <= '1';
    sza <= '1';
    s_Imm20 <= x"10010";
    s_alusrc <= '1';
    s_adsb <= '1';
    s_RD <= "11001";
    wait for cCLK_PER;
    
-- addi x25, zero, 0
    sza <= '0';
    sse <= '1';
    s_rs1 <= "00000";
    s_Imm12 <= x"000";
    s_RD <= "11001";
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- addi x26, zero, 256
    s_RD <= "11010";
    s_Imm12 <= x"100";
    wait for cCLK_PER;
    
-- lw x1, 0(x25)
    -- immediate bit Extender set
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"000";
    -- regfile data in set
    slw <= '1';
    -- memory input set
    ssw <= '0';
    -- set register input and read desitinations
    s_RD <= "00001";
    s_rs1 <= "11001";
    -- set ALU/MUX2 input and output
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- lw x2, 4(x25)
    -- immediate bit Extender set
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"004";
    -- regfile data in set
    slw <= '1';
    -- memory input set
    ssw <= '0';
    -- set register input and read desitinations
    s_RD <= "00010";
    s_rs1 <= "11001";
    -- set ALU/MUX2 input and output
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- add x1, x1, x2
    -- immediate bit Extender set
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '0';
    s_Imm12 <= x"000";
    -- regfile data in set
    slw <= '0';
    -- memory input set
    ssw <= '0';
    -- set register input and read desitinations
    s_RD <= "00001";
    s_rs1 <= "00001";
    s_rs2 <= "00010";
    -- set ALU/MUX2 input and output
    s_alusrc <= '0';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- sw x1, 0(x26)
    -- immediate bit Extender set
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"000";
    -- regfile data in set
    slw <= '0';
    -- memory input set
    ssw <= '1';
    -- set register input and read desitinations
    s_RD <= "00000";
    s_rs1 <= "11010";
    s_rs2 <= "00001";
    -- set ALU/MUX2 input and output
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;

-- lw x2, 8(x25)
    -- immediate bit Extender set
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"008";
    -- regfile data in set
    slw <= '1';
    -- memory input set
    ssw <= '0';
    -- set register input and read desitinations
    s_RD <= "00010";
    s_rs1 <= "11001";
    -- set ALU/MUX2 input and output
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;

-- add x1, x1, x2
    -- immediate bit Extender set
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '0';
    s_Imm12 <= x"000";
    -- regfile data in set
    slw <= '0';
    -- memory input set
    ssw <= '0';
    -- set register input and read desitinations
    s_RD <= "00001";
    s_rs1 <= "00001";
    s_rs2 <= "00010";
    -- set ALU/MUX2 input and output
    s_alusrc <= '0';
    s_adsb <= '0';
    wait for cCLK_PER;

-- sw x1, 4(x26)
    -- immediate bit Extender set
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"004";
    -- regfile data in set
    slw <= '0';
    -- memory input set
    ssw <= '1';
    -- set register input and read desitinations
    s_RD <= "00000";
    s_rs1 <= "11010";
    s_rs2 <= "00001";
    -- set ALU/MUX2 input and output
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
-- lw x2, 12(x25) - Load A[3] into x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"00C";
    slw <= '1';
    ssw <= '0';
    s_RD <= "00010";
    s_rs1 <= "11001";
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- add x1, x1, x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '0';
    s_Imm12 <= x"000";
    slw <= '0';
    ssw <= '0';
    s_RD <= "00001";
    s_rs1 <= "00001";
    s_rs2 <= "00010";
    s_alusrc <= '0';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- sw x1, 8(x26) - Store x1 into B[2]
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"008";
    slw <= '0';
    ssw <= '1';
    s_RD <= "00000";
    s_rs1 <= "11010";
    s_rs2 <= "00001";
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- lw x2, 16(x25) - Load A[4] into x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"010";
    slw <= '1';
    ssw <= '0';
    s_RD <= "00010";
    s_rs1 <= "11001";
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- add x1, x1, x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '0';
    s_Imm12 <= x"000";
    slw <= '0';
    ssw <= '0';
    s_RD <= "00001";
    s_rs1 <= "00001";
    s_rs2 <= "00010";
    s_alusrc <= '0';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- sw x1, 12(x26) - Store x1 into B[3]
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"00C";
    slw <= '0';
    ssw <= '1';
    s_RD <= "00000";
    s_rs1 <= "11010";
    s_rs2 <= "00001";
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- lw x2, 20(x25) - Load A[5] into x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"014";
    slw <= '1';
    ssw <= '0';
    s_RD <= "00010";
    s_rs1 <= "11001";
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- add x1, x1, x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '0';
    s_Imm12 <= x"000";
    slw <= '0';
    ssw <= '0';
    s_RD <= "00001";
    s_rs1 <= "00001";
    s_rs2 <= "00010";
    s_alusrc <= '0';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- sw x1, 16(x26) - Store x1 into B[4]
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"010";
    slw <= '0';
    ssw <= '1';
    s_RD <= "00000";
    s_rs1 <= "11010";
    s_rs2 <= "00001";
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- lw x2, 24(x25) - Load A[6] into x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"018";
    slw <= '1';
    ssw <= '0';
    s_RD <= "00010";
    s_rs1 <= "11001";
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- add x1, x1, x2
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '0';
    s_Imm12 <= x"000";
    slw <= '0';
    ssw <= '0';
    s_RD <= "00001";
    s_rs1 <= "00001";
    s_rs2 <= "00010";
    s_alusrc <= '0';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- addi x27, zero, 512 - Load &B[64] into x27
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"200";  -- 512 in hex
    slw <= '0';
    ssw <= '0';
    s_RD <= "11011";    -- x27
    s_rs1 <= "00000";   -- zero
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    
-- sw x1, -4(x27) - Store x1 into B[63]
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"FFC";  -- -4 in two's complement (12-bit)
    slw <= '0';
    ssw <= '1';
    s_RD <= "00000";
    s_rs1 <= "11011";   -- x27
    s_rs2 <= "00001";   -- x1
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;

-- addi x28, x25, 784 - add x25 + 0x310 into x28
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"310";  -- 784 in hex
    slw <= '0';
    ssw <= '0';
    s_RD <= "11100";    -- x28
    s_rs1 <= "11001";   -- x25
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;

-- add random to x29
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"12F";  -- 256+32+15 = 303
    slw <= '0';
    ssw <= '0';
    s_RD <= "11101";    -- x27
    s_rs1 <= "00000";   -- zero
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;

-- sw x29, 24(x28)
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"018";  -- decimal 24 in hex (12-bit)
    slw <= '0';
    ssw <= '1';
    s_RD <= "00000";
    s_rs1 <= "11100";   -- x28
    s_rs2 <= "11101";   -- x29
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;

-- lw x30, 24(x28)
    sse20 <= '0';
    sze <= '0';
    sza <= '0';
    sse <= '1';
    s_Imm12 <= x"018";  -- decimal 24 in hex (12-bit)
    slw <= '1';
    ssw <= '0';
    s_RD <= "11110";
    s_rs1 <= "11100";   -- x28
    s_rs2 <= "00000";   -- x29
    s_alusrc <= '1';
    s_adsb <= '0';
    wait for cCLK_PER;
    wait;
end process;

end mixed;
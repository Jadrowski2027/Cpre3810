library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_arr.all;

entity tb_riscv_datpat is
  generic(gCLK_HPER   : time := 50 ns;
          WR_SEL  : integer := 5;
          RD_SEL  : integer := 5;
          D_WIDTH   : integer := 32;
          NUM_REG : integer := 32);
end tb_riscv_datpat;


architecture mixed of tb_riscv_datpat is

  constant cCLK_PER  : time := gCLK_HPER * 2;


  component riscv_datpat
    generic(
        WR_SEL   : integer := WR_SEL;
        RD_SEL   : integer := RD_SEL;
        DATA_WIDTH       : integer := D_WIDTH;
        NUM_REG : integer := NUM_REG);
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
    end component;

    signal s_CLK, s_RST, s_RWr, s_adsb, s_alusrc, s_ovf : std_logic;
    signal s_RD : std_logic_vector(WR_SEL-1 downto 0);
    signal s_rs1, s_rs2 : std_logic_vector(RD_SEL-1 downto 0);
    signal s_Imm : std_logic_vector(D_WIDTH - 1 downto 0);


begin

    DUT: riscv_datpat
    port map(CLK => s_CLK,
            RST => s_RST,
            RegWr => s_RWr,
            naddsub => s_adsb,
            ALUSrc => s_alusrc,
            RD => s_RD,
            RS1 => s_rs1,
            RS2 => s_rs2,
            IMM => s_Imm,
            OVF => s_OVF);

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
    s_RWr <= '0';
    wait for cCLK_PER;
    s_RST <= '0';
    
    -- addi x1, zero, 1
    s_RWr <= '1';
    s_alusrc <= '1';
    s_adsb <= '0';
    s_RD <= "00001";
    s_rs1 <= "00000";
    s_rs2 <= "00000";
    s_Imm <= x"00000001";
    wait for cCLK_PER;
    
    -- addi x2, zero, 2
    s_RD <= "00010";
    s_Imm <= x"00000002";
    wait for cCLK_PER;
    
    -- addi x3, zero, 3
    s_RD <= "00011";
    s_Imm <= x"00000003";
    wait for cCLK_PER;
    
    -- addi x4, zero, 4
    s_RD <= "00100";
    s_Imm <= x"00000004";
    wait for cCLK_PER;
    
    -- addi x5, zero, 5
    s_RD <= "00101";
    s_Imm <= x"00000005";
    wait for cCLK_PER;
    
    -- addi x6, zero, 6
    s_RD <= "00110";
    s_Imm <= x"00000006";
    wait for cCLK_PER;
    
    -- addi x7, zero, 7
    s_RD <= "00111";
    s_Imm <= x"00000007";
    wait for cCLK_PER;
    
    -- addi x8, zero, 8
    s_RD <= "01000";
    s_Imm <= x"00000008";
    wait for cCLK_PER;
    
    -- addi x9, zero, 9
    s_RD <= "01001";
    s_Imm <= x"00000009";
    wait for cCLK_PER;
    
    -- addi x10, zero, 10
    s_RD <= "01010";
    s_Imm <= x"0000000A";
    wait for cCLK_PER;
    
    -- add x11, x1, x2 -> x11 = 3
    s_alusrc <= '0';
    s_adsb <= '0';
    s_RD <= "01011";
    s_rs1 <= "00001";
    s_rs2 <= "00010";
    wait for cCLK_PER;
    
    -- sub x12, x11, x3 -> x12 = 0
    s_adsb <= '1';
    s_RD <= "01100";
    s_rs1 <= "01011";
    s_rs2 <= "00011";
    wait for cCLK_PER;
    
    -- add x13, x12, x4 -> x13 = 4
    s_adsb <= '0';
    s_RD <= "01101";
    s_rs1 <= "01100";
    s_rs2 <= "00100";
    wait for cCLK_PER;
    
    -- sub x14, x13, x5 -> x14 = -1
    s_adsb <= '1';
    s_RD <= "01110";
    s_rs1 <= "01101";
    s_rs2 <= "00101";
    wait for cCLK_PER;
    
    -- add x15, x14, x6 -> x15 = 5
    s_adsb <= '0';
    s_RD <= "01111";
    s_rs1 <= "01110";
    s_rs2 <= "00110";
    wait for cCLK_PER;
    
    -- sub x16, x15, x7 -> x16 = -2
    s_adsb <= '1';
    s_RD <= "10000";
    s_rs1 <= "01111";
    s_rs2 <= "00111";
    wait for cCLK_PER;
    
    -- add x17, x16, x8 -> x17 = 6
    s_adsb <= '0';
    s_RD <= "10001";
    s_rs1 <= "10000";
    s_rs2 <= "01000";
    wait for cCLK_PER;
    
    -- sub x18, x17, x9 -> x17 = -3
    s_adsb <= '1';
    s_RD <= "10010";
    s_rs1 <= "10001";
    s_rs2 <= "01001";
    wait for cCLK_PER;
    
    -- add x19, x18, x10 -> x19 = 7
    s_adsb <= '0';
    s_RD <= "10011";
    s_rs1 <= "10010";
    s_rs2 <= "01010";
    wait for cCLK_PER;
    
    -- addi x20, zero, -35 -> x20 = -35
    s_alusrc <= '1';
    s_adsb <= '0';
    s_RD <= "10100";
    s_rs1 <= "00000";
    s_rs2 <= "00000";
    s_Imm <= x"FFFFFFDD";  -- Two's complement of -35
    wait for cCLK_PER;
    
    -- add x21, x19, x20 -> x21 = -28
    s_alusrc <= '0';
    s_RD <= "10101";
    s_rs1 <= "10011";
    s_rs2 <= "10100";
    wait for cCLK_PER;
    
    -- lui x22 0xFEED2000
    s_alusrc <= '1';
    s_adsb <= '1';
    s_RD <= "10110";
    s_Imm <= x"FEED2000";
    wait for cCLK_PER;
    
    -- addi x22, x22, x00000050
    s_adsb <= '0';
    s_RD <= "10110";
    s_rs1 <= "10110";
    s_Imm <= x"00000050";
    wait for cCLK_PER;

    s_RD <= "00000";
    s_Imm <= x"00000000";
    wait for cCLK_PER;

    wait;
end process;

    end mixed;
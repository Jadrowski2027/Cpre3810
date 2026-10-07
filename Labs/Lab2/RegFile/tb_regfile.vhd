library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_arr.all;

entity tb_regfile is
  generic(gCLK_HPER   : time := 50 ns;
          DATA_WIDTH_SEL : integer := 5;
          NUM_CH         : integer := 32;
          D_WIDTH  : integer := 32);
end tb_regfile;


architecture mixed of tb_regfile is

  constant cCLK_PER  : time := gCLK_HPER * 2;


  component regfile
    generic(
        NUM_REG           : integer := NUM_CH;
        WR_SEL   : integer := DATA_WIDTH_SEL;
        RD_SEL   : integer := DATA_WIDTH_SEL;
        DATA_WIDTH       : integer := D_WIDTH);
    port(
        iCLK     : in std_logic;
        iRST     : in std_logic;
        we       : std_logic;
        wr_sele   : in std_logic_vector(WR_SEL - 1 downto 0);
        rd_sel1  : in std_logic_vector(RD_SEL - 1 downto 0);
        rd_sel2  : in std_logic_vector(RD_SEL - 1 downto 0);
        i_Din    : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        o_Dout1  : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        o_Dout2  : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
    end component;

    signal s_CLK, s_RST, s_we : std_logic;
    signal s_wr_sel : std_logic_vector(DATA_WIDTH_SEL-1 downto 0);
    signal s_rd_sel1 : std_logic_vector(DATA_WIDTH_SEL-1 downto 0);
    signal s_rd_sel2 : std_logic_vector(DATA_WIDTH_SEL-1 downto 0);
    signal s_Din : std_logic_vector(D_WIDTH - 1 downto 0);
    signal s_Dout1 : std_logic_vector(D_WIDTH - 1 downto 0);
    signal s_Dout2 : std_logic_vector(D_WIDTH - 1 downto 0);

begin

    DUT: regfile
    port map(iCLK => s_CLK,
            iRST => s_RST,
            we => s_we,
            wr_sele => s_wr_sel,
            rd_sel1 => s_rd_sel1,
            rd_sel2 => s_rd_sel2,
            i_Din => s_Din,
            o_Dout1 => s_Dout1,
            o_Dout2 => s_Dout2);

    P_CLK: process
    begin
        s_CLK <= '0';
        wait for gCLK_HPER;
        s_CLK <= '1';
        wait for gCLK_HPER;
    end process;
            
    P_TB: process
    begin
        s_RST <= '1';
        s_wr_sel <= b"00000";
        s_rd_sel1 <= b"00000";
        s_rd_sel2 <= b"00000";
        s_Din <= x"00000000";
        wait for cCLK_PER;
        s_RST <= '0';
        wait for cCLK_PER;

        s_we <= '1';
        s_wr_sel <= b"00001";
        s_Din <= x"11111111";
        wait for cCLK_PER;
        s_wr_sel <= b"00010";
        s_Din <= x"22222222";
        wait for cCLK_PER;
        s_wr_sel <= b"00011";
        s_Din <= x"33333333";
        wait for cCLK_PER;
        s_wr_sel <= b"11111";
        s_Din <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_rd_sel1 <= b"00001";
        s_rd_sel2 <= b"00010";
        wait for cCLK_PER;
        s_rd_sel1 <= b"00011";
        s_rd_sel2 <= b"11111";
        wait for cCLK_PER;

        s_wr_sel <= b"00000";
        s_Din <= x"DEADBEEF";
        wait for cCLK_PER;
        s_rd_sel1 <= b"00000";
        s_rd_sel2 <= b"00001";
        wait for cCLK_PER;

        wait;
    end process;

    end mixed;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_extender is
  generic(TEST_WIDTH : integer := 32;
          TEST_W_IMM1 : integer := 12;
          TEST_W_IMM2 : integer := 20);
end tb_extender;

architecture mixed of tb_extender is

  component extender
    generic(WIDTH : integer := 32;
            W_IMM1 : integer := 12;
            W_IMM2 : integer := 20);
    port(i_se    : in std_logic;
         i_se20  : in std_logic;
         i_ze    : in std_logic;
         i_za    : in std_logic;
         i_imm12 : in std_logic_vector((W_IMM1-1) downto 0);
         i_imm20 : in std_logic_vector((W_IMM2-1) downto 0);
         o_ext   : out std_logic_vector((TEST_WIDTH-1) downto 0));
  end component;

  signal s_se    : std_logic;
  signal s_se20  : std_logic;
  signal s_ze    : std_logic;
  signal s_za    : std_logic;
  signal s_imm12 : std_logic_vector((TEST_W_IMM1-1) downto 0);
  signal s_imm20 : std_logic_vector((TEST_W_IMM2-1) downto 0);
  signal s_out   : std_logic_vector((TEST_WIDTH-1) downto 0);

begin

    DUT: extender
        generic map(WIDTH => TEST_WIDTH,
                    W_IMM1 => TEST_W_IMM1,
                    W_IMM2 => TEST_W_IMM2)
        port map(i_se => s_se,
                i_se20 => s_se20,
                i_ze => s_ze,
                i_za => s_za,
                i_imm12 => s_imm12,
                i_imm20 => s_imm20,
                o_ext => s_out);

    P_TEST: process
    begin

        s_se <= '1';
        s_se20 <= '0';
        s_ze <= '0';
        s_za <= '0';
        s_imm12 <= x"001";
        s_imm20 <= (others => '0');
        wait for 10 ns;
        assert s_out = x"00000001" 
        report "Test 1 FAILED: Sign extend +1" severity error;
        report "Test 1 PASSED: Sign extend 12-bit positive" severity note;
        

        s_imm12 <= x"FFF";
        wait for 10 ns;
        assert s_out = x"FFFFFFFF" 
        report "Test 2 FAILED: Sign extend -1" severity error;
        report "Test 2 PASSED: Sign extend 12-bit negative" severity note;
        

        s_imm12 <= x"800";
        wait for 10 ns;
        assert s_out = x"FFFFF800" 
        report "Test 3 FAILED: Sign extend -2048" severity error;
        report "Test 3 PASSED: Sign extend 12-bit negative -2048" severity note;
        

        s_se <= '0';
        s_ze <= '1';
        s_imm12 <= x"FFF";
        wait for 10 ns;
        assert s_out = x"00000FFF" 
        report "Test 4 FAILED: Zero extend" severity error;
        report "Test 4 PASSED: Zero extend 12-bit" severity note;
        

        s_se <= '0';
        s_se20 <= '1';
        s_ze <= '0';
        s_imm20 <= x"12345";
        wait for 10 ns;
        assert s_out = x"00012345" 
        report "Test 5 FAILED: Sign extend 20-bit positive" severity error;
        report "Test 5 PASSED: Sign extend 20-bit positive" severity note;
        

        s_imm20 <= x"FFFFF";
        wait for 10 ns;
        assert s_out = x"FFFFFFFF" 
        report "Test 6 FAILED: Sign extend 20-bit -1" severity error;
        report "Test 6 PASSED: Sign extend 20-bit negative -1" severity note;
        

        s_imm20 <= x"80000";
        wait for 10 ns;
        assert s_out = x"FFF80000" 
        report "Test 7 FAILED: Sign extend 20-bit negative" severity error;
        report "Test 7 PASSED: Sign extend 20-bit negative" severity note;
        

        -- Zero append test
        s_se20 <= '0';
        s_za <= '1';
        s_imm20 <= x"12345";
        wait for 10 ns;
        assert s_out = x"12345000" 
        report "Test 8 FAILED: Zero append / LUI" severity error;
        report "Test 8 PASSED: Zero append (LUI) instruction" severity note;
        

        s_imm20 <= x"FEED2";
        wait for 10 ns;
        assert s_out = x"FEED2000" 
        report "Test 9 FAILED: Zero append with high MSB" severity error;
        report "Test 9 PASSED: Zero append with high bits set" severity note;
        

        s_za <= '0';
        wait for 10 ns;
        assert s_out = x"00000000" report "Test 10 FAILED" severity error;
        report "Test 10 PASSED" severity note;
        
        report "====== ALL TESTS COMPLETED ======" severity note;
        wait;
    end process;

end mixed;
-------------------------------------------------------------------------
-- Justin Adrowski
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- TPU_MV_Element.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2:1 Mux
--
-- 1/16/25 by CWS::Switched from integer to std_logic_vector and numeric_std.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2t1_df is
  port(iA               : in std_logic;
       iB               : in std_logic;
       s0               : in std_logic;
       oC               : out std_logic);

end mux2t1_df;

architecture dataflow of mux2t1_df is
begin
    oC <= iA when (s0 = '0') else
          iB when (s0 = '1') else
          '0';
end dataflow;
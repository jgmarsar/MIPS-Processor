library ieee;
use ieee.std_logic_1164.all;

entity mux32 is
	port (
		in0 : in std_logic_vector(31 downto 0);
		in1 : in std_logic_vector(31 downto 0);
		Sel : in std_logic;
		O : out std_logic_vector(31 downto 0)
	);
end mux32;

architecture BHV of mux32 is
begin
	with Sel select O <= 	in0	when '0',				--if Sel == 0, O = in0
							in1	when others;			--else, O = in1
end BHV;
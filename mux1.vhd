library ieee;
use ieee.std_logic_1164.all;

entity mux1 is
	port (
		in0 : in std_logic;
		in1 : in std_logic;
		Sel : in std_logic;
		O : out std_logic
	);
end mux1;

architecture BHV of mux1 is
begin
	with Sel select O <= 	in0	when '0',				--if Sel == 0, O = in0
							in1	when others;			--else, O = in1
end BHV;
library ieee;
use ieee.std_logic_1164.all;

entity signext is
	port (
		in0 : in std_logic_vector(15 downto 0);
		out0 : out std_logic_vector(31 downto 0)
	);
end signext;

architecture BHV of signext is
begin
	out0(15 downto 0) <= in0;							--Least significant 16 bits = input
	with in0(15) select out0(31 downto 16) <= 	(others => '0')	when '0',		
												x"FFFF"			when others;			
end BHV;
library ieee;
use ieee.std_logic_1164.all;

entity zeroext is
	port (
		in0 : in std_logic_vector(15 downto 0);
		out0 : out std_logic_vector(31 downto 0)
	);
end zeroext;

architecture BHV of zeroext is
begin
	out0(15 downto 0) <= in0;					--Least significant 16 bits = input
	out0(31 downto 16) <= (others => '0');		--Most significant 16 bits = 0
end BHV;
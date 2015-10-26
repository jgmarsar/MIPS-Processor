library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftL2 is
	generic (
		widthIn : integer := 16
	);
	port (
		input : in std_logic_vector(widthIn-1 downto 0);
		output : out std_logic_vector(widthIn+1 downto 0)
	);
end entity shiftL2;

architecture RTL of shiftL2 is
	
begin
	process(input)
	begin
		output(widthIn+1 downto 2) <= input;
		output(1 downto 0) <= "00";
	end process;
end architecture RTL;
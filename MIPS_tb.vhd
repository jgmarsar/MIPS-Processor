library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS_tb is
end MIPS_tb;

architecture Test of MIPS_tb is
	signal clk : std_logic := '1';
	signal mclk : std_logic := '1';
	signal rst : std_logic := '1';
begin
	
	clk <= not clk after 60 ns;
	mclk <= not mclk after 20 ns;
	
	process
	begin
		wait for 120 ns;
		rst <= '0';
		wait;
	end process;
	
end architecture Test;

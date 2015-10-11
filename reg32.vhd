library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg32 is
	generic (
		reset : unsigned := x"00000000"						--upon reset, the register will be set to this value
	);
	port (
		D : in std_logic_vector(31 downto 0);
		wr : in std_logic;
		Clk : in std_logic;
		clr : in std_logic;
		Q : out std_logic_vector(31 downto 0)
	);
end reg32;

architecture BHV of reg32 is
begin
	process(Clk, clr)
	begin
		if (clr = '1') then
			--if clr is enabled, Q will be set to zero, regardless of clock state (Asynchronous)
			Q <= std_logic_vector(reset);
		elsif(rising_edge(Clk)) then
			--on a rising clock edge
			if (wr = '1') then
				--if write is enabled, the data is latched into the output
				Q <= D;
				--otherwise, the output data is retained
			end if;
		end if;
	end process;
end BHV;